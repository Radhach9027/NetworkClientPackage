import Foundation

public final class NetworkSession: NSObject {
    
    private var mapTaskHandlers: [URLSessionTask : ProgressAndCompletionHandlers] = [:]
    public var session: NetworkSessionProtocol?
    
    public init(config: URLSessionConfiguration = URLSession.configuration(30, nil), queue: OperationQueue = URLSession.queue(1, .userInitiated)) {
        print("NetworkSession init")
        super.init()
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
    }
    
    deinit {
        print("NetworkSession de-init")
        dispose()
    }
}

private extension NetworkSession {
    
    typealias ProgressAndCompletionHandlers = (progress: ProgressHandler?, completion: ((URL?, URLResponse?, Error?) -> Void)?)
    
    func set(handlers: ProgressAndCompletionHandlers?, for task: URLSessionTask) {
        mapTaskHandlers[task] = handlers
    }
    
    func get(task: URLSessionTask) -> ProgressAndCompletionHandlers? {
        return mapTaskHandlers[task]
    }
    
    func dispose() {
        session?.invalidateAndCancel()
    }
}

extension NetworkSession: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let handlers = get(task: task) else { return }
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        DispatchQueue.main.async {
            handlers.progress?(progress)
        }
        set(handlers: nil, for: task)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let downloadTask = task as? URLSessionDownloadTask, let handlers = get(task: downloadTask) else { return }
        DispatchQueue.main.async {
            handlers.completion?(nil, downloadTask.response, downloadTask.error)
        }
        set(handlers: nil, for: task)
    }
    
    /****** SSL PINNING
    NOTE : Use this for SSL Pinning (Public keys or Certificate from bundle)
    1. Keep your keys SSLPinningKeys
    2. Save them to your cloud or keychain
     ******/
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
     
     if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
     if let serverTrust = challenge.protectionSpace.serverTrust {
     DispatchQueue.global().async {
     SecTrustEvaluateAsyncWithError(serverTrust, DispatchQueue.global()) {
     trust, result, error in
     if result {
     // Public key pinning
     if let serverPublicKey = SecTrustCopyKey(trust), let serverPublicKeyData: NSData =  SecKeyCopyExternalRepresentation(serverPublicKey, nil) {
     let keyHash = serverPublicKeyData.description.sha256()
     if (keyHash == SSLPinningKeys.pinnedPublicKeyHash) {
     completionHandler(.useCredential, URLCredential(trust:serverTrust))
     return
     }
     }
     
     // Certificates pinning
     /*if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
     let serverCertificateData:NSData = SecCertificateCopyData(serverCertificate)
     let certHash = serverCertificateData.description.sha256()
     if (certHash == SSLPinningKeys.pinnedCertificateHash) {
     completionHandler(.useCredential, URLCredential(trust:serverTrust))
     return
     }
     }*/
     
     } else {
     print("Trust failed: \(error!.localizedDescription)")
     }
     }
     }
     }
     }
     completionHandler(.cancelAuthenticationChallenge, nil)
     }*/
}


extension NetworkSession: URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let getHandlers = get(task: downloadTask) else { return }
        DispatchQueue.main.async {
            getHandlers.completion?(location, downloadTask.response, downloadTask.error)
        }
        set(handlers: nil, for: downloadTask)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let getHandlers = get(task: downloadTask) else { return }
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            getHandlers.progress?(progress)
        }
    }
}
