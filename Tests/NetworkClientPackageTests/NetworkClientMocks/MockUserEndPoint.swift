@testable import NetworkClientPackage

enum MockUserEndPoint {
    case all
    case download(id: String)
}

extension MockUserEndPoint: NetworkRequestProtocol {
    
    var path: String {
        switch self {
            case .all:
                return "/users"
            case let .download(id):
                return "/wp-content/uploads/2015/12/"+"\(id)"
        }
    }
    
    var method: NetworkRequestMethod {
        switch self {
            case .all, .download(_):
                return .get
        }
    }
    
    var requestType: NetworkRequestType {
        switch self {
            case .all:
                return .data
            case .download(_):
                return .download
        }
    }
    
    var responseType: NetworkResponseType {
        switch self {
            case .all:
                return .json
            case .download(_):
                return .file
        }
    }
}
