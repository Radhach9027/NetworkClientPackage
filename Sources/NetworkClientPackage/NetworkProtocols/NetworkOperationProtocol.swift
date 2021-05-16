public protocol NetworkOperationProtocol {
    associatedtype RequestOutput
    var request: NetworkRequestProtocol { get }
    func fetch(in requestDispatcher: NetworkRequestDispatchProtocol, completion: @escaping (RequestOutput) -> Void) ->  Void
    func cancel() -> Void
    func killAll(in requestDispatcher: NetworkRequestDispatchProtocol)
}
