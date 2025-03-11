import SwiftUI

struct DomainRowView: View {
    let domain: Domain
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(domain.domain)
                    .font(.headline)
                 Text("Zone: \(String(describing: domain.zone))")
                     .font(.subheadline)
                     .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Available")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.green)
                .cornerRadius(5)
        }
        .padding(.vertical, 5)
        .contentShape(Rectangle()) // Improve tap area
    }
}

// Preview provider for SwiftUI Canvas
struct DomainRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleDomain = Domain(
            domain: "example.com",
            zone: "com",
            createDate: "2022-01-01",
            updateDate: "2022-01-01",
            country: "US",
            isDead: "False",
            aRecords: ["192.168.1.1"],
            nsRecords: ["ns1.example.com", "ns2.example.com"]
        )
        
        return DomainRowView(domain: sampleDomain)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
