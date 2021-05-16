import Foundation

public protocol NetworkRequestDispatchProtocol {
    init(environment: NetworkEnvironmentProtocol, networkSession: NetworkSessionProtocol)
    func fetch(request: NetworkRequestProtocol, completion: @escaping (NetworkOperationResult) -> Void) -> NetworkSessionTaskProtocol?
    func killAllServices()
}
