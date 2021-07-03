import XCTest
@testable import NetworkClientPackage
    
final class NetworkClientPackageTests: XCTestCase {
    
    private var requestDispatcher: NetworkRequestDispatcher?
    
    override func setUp() {
        super.setUp()
        requestDispatcher = NetworkRequestDispatcher(environment: MockNetworkEnvironment.dev, networkSession: NetworkSessionMock())
    }
    
    override func tearDown() {
        super.tearDown()
        requestDispatcher = nil
    }
    
    // test data task ---> Should return expected mock model -- AAA
    func testDataTaskSession_StubNetworkAction_ThenShouldReturnExpetcedMockModel() {
        ///ARRANGE & ACT
        let networkAction = NetworkAction()
        let request = MockUserEndPoint.all
        ///ASSERT
        XCTAssertEqual(request.method.rawValue, NetworkRequestMethod.get.rawValue)
        XCTAssertEqual(request.requestType, NetworkRequestType.data)
        XCTAssertEqual(request.responseType, NetworkResponseType.json)
        XCTAssertEqual(request.path, "/users")
        guard let dispatcher = requestDispatcher else { return XCTAssertThrowsError("requestDispatcher is nil")}
        
        ///ACT
        networkAction.fetch(request: request, in: dispatcher) { result in
            ///ASSERT
            switch result {
                case  let .json(_, data):
                    XCTAssertNotNil(data)
                    XCTAssertTrue(true)
                    if let data = data, let modelObj = try? JSONDecoder().decode([MockUser].self, from: data) {
                        XCTAssertEqual(modelObj, URLSessionDataTaskMock.fakeUser)
                    }
                    break
                case let .error(error, _):
                    XCTAssertThrowsError(error?.localizedDescription)
                    break
                default:
                    break
            }
        }
    }
}
