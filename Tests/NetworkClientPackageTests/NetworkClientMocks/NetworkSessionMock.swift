@testable import NetworkClientPackage
import Foundation

class NetworkSessionMock: NetworkSessionProtocol {

    var invalidate_cancel = 0
    var killAllServices = 0
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock(completionHandler: completionHandler, url: url)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock(completionHandler: completionHandler, request: request)
    }
    
    func downloadTask(with request: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        return URLSessionDownloadTaskMock(completionHandler: completionHandler, request: request)
    }
    
    func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        return URLSessionUploadTaskMock(completionHandler: completionHandler, request: request)
    }
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        return URLSessionUploadTaskMock(completionHandler: completionHandler, request: request)
    }
    
    func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        return URLSessionDownloadTaskMock(completionHandler: completionHandler, url: url)
    }
    
    func downloadTask(withResumeData resumeData: Data, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        return URLSessionDownloadTaskMock(completionHandler: completionHandler, data: resumeData)
    }
    
    func invalidateAndCancel() {
        invalidate_cancel += 1
    }
    
    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
        killAllServices += 1
    }
}
