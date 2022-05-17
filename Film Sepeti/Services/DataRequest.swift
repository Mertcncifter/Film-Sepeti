//
//  DataRequest.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public struct DataRequest {
    var url: String
    var method: HTTPMethod
    var headers: [String : String] = [:]
    var queryItems: [String : String] = [:]
}
