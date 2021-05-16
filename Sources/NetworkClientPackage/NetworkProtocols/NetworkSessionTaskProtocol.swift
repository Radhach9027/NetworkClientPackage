import Foundation

public protocol NetworkSessionTaskProtocol: AnyObject {
    func cancel()
    func suspend()
    func resume()
}

extension URLSessionTask: NetworkSessionTaskProtocol {}
