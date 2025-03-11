import Foundation

struct Domain: Identifiable, Decodable {
    let id = UUID()
    let domain: String
    let zone: String?
    let createDate: String
    let updateDate: String
    let country: String?
    let isDead: String?
    let aRecords: [String]?
    let nsRecords: [String]?
    let cnameRecords: [String]?
    let mxRecords: [MXRecord]?
    let txtRecords: [String]?
    
    // Preview initializer
    init(domain: String, zone: String? = nil, createDate: String, updateDate: String, country: String? = nil, 
         isDead: String? = nil, aRecords: [String]? = nil, nsRecords: [String]? = nil, 
         cnameRecords: [String]? = nil, mxRecords: [MXRecord]? = nil, txtRecords: [String]? = nil) {
        self.domain = domain
        self.zone = zone
        self.createDate = createDate
        self.updateDate = updateDate
        self.country = country
        self.isDead = isDead
        self.aRecords = aRecords
        self.nsRecords = nsRecords
        self.cnameRecords = cnameRecords
        self.mxRecords = mxRecords
        self.txtRecords = txtRecords
    }
    
    enum CodingKeys: String, CodingKey {
        case domain
        case zone = "zone"
        case createDate = "create_date"
        case updateDate = "update_date"
        case country
        case isDead = "isDead"
        case aRecords = "A"
        case nsRecords = "NS"
        case cnameRecords = "CNAME"
        case mxRecords = "MX"
        case txtRecords = "TXT"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        domain = try container.decode(String.self, forKey: .domain)
        zone = try? container.decodeIfPresent(String.self, forKey: .zone)
        createDate = try container.decode(String.self, forKey: .createDate)
        updateDate = try container.decode(String.self, forKey: .updateDate)
        country = try? container.decodeIfPresent(String.self, forKey: .country)
        isDead = try? container.decodeIfPresent(String.self, forKey: .isDead)
        aRecords = try? container.decodeIfPresent([String].self, forKey: .aRecords)
        nsRecords = try? container.decodeIfPresent([String].self, forKey: .nsRecords)
        cnameRecords = try? container.decodeIfPresent([String].self, forKey: .cnameRecords)
        mxRecords = try? container.decodeIfPresent([MXRecord].self, forKey: .mxRecords)
        txtRecords = try? container.decodeIfPresent([String].self, forKey: .txtRecords)
    }
}

struct MXRecord: Decodable {
    let exchange: String
    let priority: Int
}

struct DomainResponse: Decodable {
    let domains: [Domain]
    let total: Int
    let time: String
}

// Network error handling
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check your search term."
        case .noData:
            return "No data received from server."
        case .decodingError:
            return "Could not process the data from server."
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
