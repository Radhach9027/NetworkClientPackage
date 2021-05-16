import Foundation

class URLSessionUploadTaskMock: URLSessionUploadTask {
    
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var request: URLRequest?
    var url: URL?
    var resumeRequest = false
    var cancelRequest = false
    var suspendRequest = false
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, request: URLRequest? = nil, url: URL? = nil) {
        self.completionHandler = completionHandler
        self.request = request
        self.url = url
    }
    
    override func resume() {
        resumeRequest = true
    }
    
    override func cancel() {
        cancelRequest = true
    }
    
    override func suspend() {
        suspendRequest = true
    }
}
