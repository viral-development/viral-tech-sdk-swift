import Foundation

let DEFAULT_API_URL = "https://viral.tech/api/v1"

// Define our Result type
public enum ApiError: Error {
    case networkError(Error)
    case invalidUrl
    case invalidResponse
    case serverError(Int)
}

typealias ApiResult<T> = Result<T, ApiError>

public struct ViralTechOptions {
    let apiKey: String
    let apiUrl: String?
}

@available(iOS 13.0.0, *)
public class ViralTech {
    private let apiKey: String
    private let apiUrl: String
    
    init(options: ViralTechOptions) {
        self.apiKey = options.apiKey
        self.apiUrl = options.apiUrl ?? DEFAULT_API_URL
    }
    
    func logDownload() async -> ApiResult<Void> {
        return await makeApiRequest(
            url: "\(apiUrl)/log-download",
            method: "POST",
            headers: ["Authorization": "Bearer \(apiKey)"]
        )
    }
    
    func logConversion() async -> ApiResult<Void> {
        return await makeApiRequest(
            url: "\(apiUrl)/log-conversion",
            method: "POST",
            headers: ["Authorization": "Bearer \(apiKey)"]
        )
    }
}

// Helper function to make API requests
@available(iOS 13.0.0, *)
func makeApiRequest(url urlString: String, method: String, headers: [String: String]) async -> ApiResult<Void> {
    guard let url = URL(string: urlString) else {
        return .failure(.invalidUrl)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    headers.forEach { key, value in
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            return .success(())
        } else {
            return .failure(.serverError(httpResponse.statusCode))
        }
    } catch {
        return .failure(.networkError(error))
    }
}
