import Foundation

public final class NetworkAction: NetworkOperationProtocol {
    
    private var task: NetworkSessionTaskProtocol?
    public var request: NetworkRequestProtocol
    
    public init(request: NetworkRequestProtocol) {
        self.request = request
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    public func fetch(in requestDispatcher: NetworkRequestDispatchProtocol, completion: @escaping (NetworkOperationResult) -> Void) {
        
        if NetworkReachability.shared.isReachable {
            task = requestDispatcher.fetch(request: request, completion: { result in
                completion(result)
            })
        } else {
            completion(.error(nil, nil, .noInternet))
        }
    }
    
    public func killAll(in requestDispatcher: NetworkRequestDispatchProtocol) {
        requestDispatcher.killAllServices()
    }
}
