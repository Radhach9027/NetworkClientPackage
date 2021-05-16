import Foundation

public protocol NetworkSessionProtocol: AnyObject {

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    
    func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask

    func downloadTask(with request: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
    
    func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
    
    func downloadTask(withResumeData resumeData: Data, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
    
    func invalidateAndCancel()
    
    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void)
}


extension URLSession: NetworkSessionProtocol {

    public static var queue:(Int, QualityOfService) -> OperationQueue = { (maxOperationCount, userService) in
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxOperationCount
        queue.qualityOfService = userService
        return queue
    }
    
    public static var configuration:(Double, String?) -> URLSessionConfiguration = { (timeInterval, identifier) in
        var configuration: URLSessionConfiguration =  identifier != nil ? .background(withIdentifier: identifier!) : .default
        configuration.timeoutIntervalForResource = timeInterval
        if #available(iOS 11, *) {
            configuration.waitsForConnectivity = true
        }
        return configuration
    }
}
