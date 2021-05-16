import UIKit

public enum NetworkMessages: String {
    
    case internet = "Hey Seems to have good internet connectivity..Let's ride the app..😃"
    case noInternet = "As it seems there is no network connection available on the device, please check and try again..😟"
    
    enum ApiError {
        case api(Error)
        
        func errorMessages() -> String {
            switch self {
                case let .api(error):
                    return error.localizedDescription
            }
        }
    }
}
