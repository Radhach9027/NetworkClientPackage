import Foundation

class URLSessionDownloadTaskMock: URLSessionDownloadTask {
    
    var completionHandler: (URL?, URLResponse?, Error?) -> Void
    var request: URLRequest?
    var url: URL?
    var data: Data?
    var resumeRequest = false
    var cancelRequest = false
    var suspendRequest = false
    
    init(completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void, request: URLRequest? = nil, url: URL? = nil, data: Data? = nil) {
        self.completionHandler = completionHandler
        self.request = request
        self.url = url
        self.data = data
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
