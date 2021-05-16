import Foundation

public protocol NetworkParserProtocol {
    func convertDataToModel<T: Codable>(data: Data?, decodingType: T.Type) -> Result<Codable?, NetworkError>
}

extension NetworkParserProtocol {
    
    public func convertDataToModel<T: Codable>(data: Data?, decodingType: T.Type) -> Result<Codable?, NetworkError> {
        guard let data = data else { return .failure(.invalidResponse) }
        
        do {
            let model = try JSONDecoder().decode(decodingType, from: data)
            return .success(model)
            
        } catch (let exception) {
            return .failure(.parseError(exception.localizedDescription))
        }
    }
}
