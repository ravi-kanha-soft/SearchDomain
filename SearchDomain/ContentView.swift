import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DomainSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                searchBar
                
                // Main content area
                ZStack {
                    // Loading state
                    if viewModel.isLoading {
                        loadingView
                    }
                    // Error state
                    else if let error = viewModel.error {
                        errorView(message: error)
                    }
                    // Empty results state
                    else if viewModel.searchPerformed && viewModel.domains.isEmpty {
                        emptyResultsView
                    }
                    // Results list
                    else if !viewModel.domains.isEmpty {
                        resultsList
                    }
                    // Initial state - show helpful tips
                    else {
                        initialStateView
                    }
                }
            }
            .navigationTitle("Domain Search")
        }
    }
    
    // MARK: - Component Views
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search for domains...", text: $viewModel.searchText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: viewModel.searchText) { newValue in
                    viewModel.onSearchTextChanged()
                }
                .accessibilityLabel("Search domains")
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Searching domains...")
            Spacer()
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            Button("Try Again") {
                viewModel.search()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding()
        .onAppear {
            // Error haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
    
    private var emptyResultsView: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No domains found")
                .font(.headline)
                .padding(.top)
            Text("Try a different search term")
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private var resultsList: some View {
        List {
            ForEach(viewModel.domains) { domain in
                NavigationLink(destination: PurchaseView(domain: domain)) {
                    DomainRowView(domain: domain)
                }
            }
        }
        .listStyle(PlainListStyle())
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.domains.count)
    }
    
    private var initialStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "globe")
                .font(.system(size: 70))
                .foregroundColor(.blue.opacity(0.7))
            
            Text("Find Your Perfect Domain")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 10) {
                TipRow(icon: "1.circle.fill", text: "Enter at least 3 characters")
                TipRow(icon: "2.circle.fill", text: "Include TLD for specific search (e.g., example.com)")
                TipRow(icon: "3.circle.fill", text: "Tap a result to view purchase options")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Supporting Views

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Preview Provider

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
