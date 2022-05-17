//
//  NetworkService.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import Foundation

enum ErrorResponse: String{
    case invalidEndpoint = ""
}


final class NetworkService {
    
    static let shared = NetworkService()
    
    func request(_ request: DataRequest, completion: @escaping (
        Result<[Movie], Error>) -> Void) {
    
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NSError()))
            }
            
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
