import Foundation

public protocol NetworkRequestProtocol {
    var path: String { get }
    var method: NetworkRequestMethod { get }
    var headers: ReaquestHeaders? { get }
    var parameters: RequestParameters? { get }
    var requestType: NetworkRequestType { get }
    var responseType: NetworkResponseType { get }
    var progressHandler: ProgressHandler? { get }
}

extension NetworkRequestProtocol {
    
    public func urlRequest(with environment: NetworkEnvironmentProtocol) -> URLRequest? {
        
        guard let url = url(with: environment.baseURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonBody
        
        return request
    }
    
    
    private func url(with baseURL: String) -> URL? {
        
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    private var queryItems: [URLQueryItem]? {
        
        guard method == .get, let parameters = parameters else { return nil }
        
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }
    
    private var jsonBody: Data? {
        
        guard [.post, .put, .patch].contains(method), let parameters = parameters else { return nil }
        
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
    
    var headers: ReaquestHeaders? {
        return nil
    }
            
    var progressHandler: ProgressHandler? {
        get { nil }
    }
    
    var parameters: RequestParameters? {
        get { nil }
    }
}
