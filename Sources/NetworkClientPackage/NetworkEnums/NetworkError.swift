import Foundation

public enum NetworkError: Error {
    
    case noData
    case invalidResponse
    case badRequest(String?)
    case serverError(String?)
    case parseError(String?)
    case unknown
    case outdated
    
    var localizedDescription: String {
        
        switch self {
            case .noData: return "Request Failed or Invalid URL"
            case .invalidResponse: return "Response Unsuccessful."
            case .badRequest: return "Bad Request"
            case .outdated: return "The URL requested is outdated."
            case .unknown: return "Some Unknow error occured."
            default:
                break
        }
        return "Unknow error occured."
    }
}

extension NetworkError {
    
    static func validateHTTPError(data: Any?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Any, NetworkError> {
        
        switch urlResponse.statusCode {
            case 200...299:
                if let data = data {
                    return .success(data)
                } else {
                    return .failure(.noData)
                }
            case 400...499:
                return .failure(.badRequest(error?.localizedDescription))
            case 500...599:
                return .failure(.serverError(error?.localizedDescription))
            case 600:
                return .failure(.serverError(error?.localizedDescription))
            default:
                return .failure(.unknown)
        }
    }
}
