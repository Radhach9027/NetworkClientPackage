import Foundation

public final class NetworkAction: NetworkOperationProtocol {
    
    private var task: NetworkSessionTaskProtocol?
    
    public init() {}

    public func cancel() {
        task?.cancel()
    }

    public func fetch(request: NetworkRequestProtocol, in requestDispatcher: NetworkRequestDispatchProtocol, completion: @escaping (NetworkOperationResult) -> Void) {
        
        if NetworkReachability.shared.isReachable {
            task = requestDispatcher.fetch(request: request, completion: { result in
                completion(result)
            })
        } else {
            completion(.noInternet(.noInternet))
        }
    }
    
    public func killAll(in requestDispatcher: NetworkRequestDispatchProtocol) {
        requestDispatcher.killAllServices()
    }
}
