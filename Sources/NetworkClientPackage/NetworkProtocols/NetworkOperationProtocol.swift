public protocol NetworkOperationProtocol {
    associatedtype RequestOutput
    func fetch(request: NetworkRequestProtocol, in requestDispatcher: NetworkRequestDispatchProtocol, completion: @escaping (RequestOutput) -> Void) ->  Void
    func cancel() -> Void
    func killAll(in requestDispatcher: NetworkRequestDispatchProtocol)
}
