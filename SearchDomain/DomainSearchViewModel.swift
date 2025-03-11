import SwiftUI
import Combine

class DomainSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var domains: [Domain] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    @Published var searchPerformed = false
    
    // For debouncing search
    private var searchDebounce: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    // For tracking network tasks
    private var currentTask: URLSessionDataTask?
    
    init() {
        // Set up debounced search publisher
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                if text.count >= 3 {
                    self?.performSearch(text: text)
                } else if text.isEmpty {
                    self?.clearResults()
                }
            }
            .store(in: &cancellables)
    }
    
    func onSearchTextChanged() {
        // The debounce logic is handled in the publisher
        // This method can be called directly from the UI
        if searchText.count < 3 {
            clearResults()
        }
    }
    
    private func clearResults() {
        domains = []
        error = nil
        searchPerformed = false
    }
    
    func performSearch(text: String) {
        // Cancel any ongoing search
        currentTask?.cancel()
        
        isLoading = true
        searchPerformed = true
        error = nil
        
        // Extract domain and zone from the search text
        let searchComponents = text.split(separator: ".")
        var domain = text
        var zone = "com" // Default zone
        
        if searchComponents.count > 1 {
            domain = String(searchComponents.first ?? "")
            zone = String(searchComponents.last ?? "com")
        }
        
        print("Searching for domain: \(domain), zone: \(zone)")
        
        // URL encode the search parameters
        guard let encodedDomain = domain.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.domainsdb.info/v1/domains/search?domain=\(encodedDomain)&zone=\(zone)") else {
            self.isLoading = false
            self.error = NetworkError.invalidURL.errorDescription
            return
        }
        print("Generated URL: \(url)")
        
        // Add a timeout to the request
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.timeoutInterval = 15 // 15 seconds timeout
        
        currentTask = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                // Handle network errors
                if let error = error as NSError? {
                    if error.code == NSURLErrorCancelled {
                        print("Network error: \(error.localizedDescription)")
                        // Search was cancelled, don't show error
                        return
                    }
                    
                    if error.code == NSURLErrorTimedOut {
                        self?.error = "Request timed out. Please try again."
                    } else {
                        self?.error = "Network error: \(error.localizedDescription)"
                    }
                    return
                }
                
                // Check HTTP status code
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        self?.error = "Server error: HTTP \(httpResponse.statusCode)"
                        print("HTTP Status: \(httpResponse.statusCode)")
                        return
                    }
                }
                
                guard let data = data else {
                    print("No data received")
                    self?.error = NetworkError.noData.errorDescription
                    return
                }
                print(" data received \(data)")
                // Try to decode the response
                do {
                    let response = try JSONDecoder().decode(DomainResponse.self, from: data)
                    self?.domains = response.domains
                    
                    
                    print("Found \(response.domains.count) domains")
                    
                    // Haptic feedback for successful search
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                } catch {
                    // Check if it's a "no results" response
                    if let responseString = String(data: data, encoding: .utf8),
                       responseString.contains("No data") {
                        print("Raw response: \(responseString)")
                        self?.domains = []
                    } else {
                        self?.error = "Failed to parse data: \(error.localizedDescription)"
                    }
                }
            }
        }
        
        currentTask?.resume()
    }
    
    func search() {
        performSearch(text: searchText)
    }
    
    deinit {
        // Cancel all subscriptions when view model is deallocated
        cancellables.forEach { $0.cancel() }
        currentTask?.cancel()
    }
}
