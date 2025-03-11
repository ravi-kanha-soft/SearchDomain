import SwiftUI

struct PurchaseView: View {
    let domain: Domain
    @State private var isPurchased = false
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Text(domain.domain)
                                .font(.system(size: 24, weight: .bold))
                            
                            Text("is available for purchase")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Domain \(domain.domain) is available for purchase")
                    
                    // Domain details
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 12) {
                            DetailRow(label: "Domain Name:", value: domain.domain)
                            DetailRow(label: "Zone:", value: domain.zone ?? "Not specified")
                            DetailRow(label: "Created Date:", value: domain.createDate)
                            DetailRow(label: "Update Date:", value: domain.updateDate)
                            DetailRow(label: "Country:", value: domain.country ?? "Unknown")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Pricing info (mock)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pricing")
                            .font(.headline)
                        
                        DetailRow(label: "Registration:", value: "$9.99/year", isBold: true)
                        DetailRow(label: "Privacy:", value: "Free", isBold: true)
                        
                        Divider()
                        
                        DetailRow(
                            label: "Total:",
                            value: "$9.99/year",
                            isBold: true,
                            valueColor: .blue
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Purchase Button
                    VStack {
                        if isPurchased {
                            purchaseSuccessView
                                .id("bottomID") // Add an ID for scrolling
                        } else if isLoading {
                            ZStack {
                                Color.clear // This ensures the ZStack takes full space
                                VStack {
                                    ProgressView()
                                        .scaleEffect(1.5) // Makes the spinner slightly larger
                                        .padding(.bottom, 8)
                                    Text("Processing...")
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Takes full available space
                        } else {
                            purchaseButton
                        }
                    }
                    .padding()
                    .animation(.easeInOut, value: isPurchased)
                    .animation(.easeInOut, value: isLoading)
                    .onChange(of: isPurchased) { newValue in
                        if newValue {
                            withAnimation {
                                proxy.scrollTo("bottomID", anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Purchase Domain")
    }
    
    // Extract views for better readability
    private var purchaseSuccessView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Purchase Successful!")
                .font(.headline)
            
            Text("Your domain \(domain.domain) has been registered successfully.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button("Back to Search") {
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .accessibilityLabel("Return to domain search")
        }
        .padding()
        .onAppear {
            // Haptic feedback for successful purchase
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    private var purchaseButton: some View {
        Button("Confirm Purchase") {
            purchaseDomain()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .accessibilityHint("Tap to complete your purchase")
    }
    
    private func purchaseDomain() {
        isLoading = true
        
        // Simulate network request with reasonable delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            withAnimation {
                isPurchased = true
            }
        }
    }
}

// Reusable component for detail rows
struct DetailRow: View {
    let label: String
    let value: String
    var isBold: Bool = false
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .fontWeight(isBold ? .bold : .regular)
                .foregroundColor(valueColor)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label) \(value)")
    }
}

// Preview provider
struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleDomain = Domain(
            domain: "example",
            zone: "com",
            createDate: "2022-01-01",
            updateDate: "2022-01-01",
            country: "US"
        )
        
        return NavigationView {
            PurchaseView(domain: sampleDomain)
        }
    }
}
