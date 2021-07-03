import Foundation

public final class NetworkRequestDispatcher {
    
    private var environment: NetworkEnvironmentProtocol
    private var networkSession: NetworkSessionProtocol
    
    public required init(environment: NetworkEnvironmentProtocol, networkSession: NetworkSessionProtocol) {
        self.environment = environment
        self.networkSession = networkSession
    }
}

extension NetworkRequestDispatcher: NetworkRequestDispatchProtocol {
    
    public func fetch(request: NetworkRequestProtocol, completion: @escaping (NetworkOperationResult) -> Void) -> NetworkSessionTaskProtocol? {
        
        guard var urlRequest = request.urlRequest(with: environment) else {
            completion(.error(NetworkError.badRequest("Invalid URL for: \(request)"), nil))
            return nil
        }
        
        environment.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })
        
        var sessionTask: NetworkSessionTaskProtocol?
        
        switch request.requestType {
            case .data:
                sessionTask = networkSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
                    self?.readURLResponse(data: data, urlResponse: urlResponse, error: error, completion: completion)
                })
            case .upload:
                sessionTask = networkSession.uploadTask(with: urlRequest, fromFile: URL(fileURLWithPath: ""), completionHandler: { [weak self] (data, urlResponse, error) in
                    self?.readURLResponse(data: data, urlResponse: urlResponse, error: error, completion: completion)
                })
            case .download:
                sessionTask = networkSession.downloadTask(with: urlRequest, completionHandler: { [weak self] (url, urlResponse, error) in
                    self?.readFileResponse(fileUrl: url, urlResponse: urlResponse, error: error, completion: completion)
                })
        }
        
        sessionTask?.resume()
        return sessionTask
    }
    
    public func killAllServices() {
        self.networkSession.getAllTasks { (tasks) in
            tasks.first(where: {$0.state == .running})?.cancel()
        }
    }
}

private extension NetworkRequestDispatcher {
    
    func readURLResponse(data: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (NetworkOperationResult) -> Void) {
        
        guard let urlResponse = urlResponse as? HTTPURLResponse else { return completion(.error(NetworkError.invalidResponse, nil)) }
        
        let result = NetworkError.validateHTTPError(data: data, urlResponse: urlResponse, error: error)
        
        switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.json(nil, data: data as? Data))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.error(error, urlResponse))
                }
        }
    }
    
    
    func readFileResponse(fileUrl: URL?, urlResponse: URLResponse?, error: Error?, completion: @escaping (NetworkOperationResult) -> Void) {
        
        guard let urlResponse = urlResponse as? HTTPURLResponse else { return completion(.error(NetworkError.invalidResponse, nil)) }
        
        let result = NetworkError.validateHTTPError(data: fileUrl, urlResponse: urlResponse, error: error)
        
        switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    completion(.file(url as? URL, urlResponse))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.error(error, urlResponse))
                }
        }
    }
}
