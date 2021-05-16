@testable import NetworkClientPackage
import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    
    var request: URLRequest?
    var url: URL?
    var resumeRequest = false
    var cancelRequest = false
    var suspendRequest = false
    
    static var fakeUser: [MockUser] {
        return [MockUser(id: 1, email: "Chandan@gmail.com", first_name: "Chandan", last_name: "Chilamkurthy", avatar: "Sample1"), MockUser(id: 2, email: "Nick@gmail.com", first_name: "Nick", last_name: "Nallik", avatar: "Sample2"), MockUser(id: 3, email: "Mitchell@gmail.com", first_name: "Mitchell", last_name: "Cassendra", avatar: "Sample3"), MockUser(id: 4, email: "Jhon@gmail.com", first_name: "Jhon", last_name: "Calbri", avatar: "Sample4")]
    }
    
    static var stubData: Data? {
        let data = try? JSONEncoder().encode(URLSessionDataTaskMock.fakeUser)
        return data
    }
    
    static var stubUrlResponse: HTTPURLResponse? {
        guard let url = URL(string: "https://reqres.in/api/users") else { return nil }
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: nil)
    }
    
    static var stubError: NetworkError? {
        return .badRequest("URLSessionDataTaskMock Fake Error")
    }

    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, request: URLRequest? = nil, url: URL? = nil) {
        self.request = request
        self.url = url
        completionHandler(URLSessionDataTaskMock.stubData, URLSessionDataTaskMock.stubUrlResponse, URLSessionDataTaskMock.stubError)
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
