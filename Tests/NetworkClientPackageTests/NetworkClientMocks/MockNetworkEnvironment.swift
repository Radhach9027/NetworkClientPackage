@testable import NetworkClient

enum MockNetworkEnvironment: NetworkEnvironmentProtocol {
    case dev
    case prod
    
    var headers: ReaquestHeaders? {
        switch self {
        case .dev:
            return [
                "Content-Type" : "application/json",
                "Accept" : "application/json"]
        case .prod:
            return [:]
        }
    }
    
    var baseURL: String {
        switch self {
        case .dev:
            return "https://reqres.in/api"
        case .prod:
            return "http://radio.spainmedia.es"
        }
    }
}
