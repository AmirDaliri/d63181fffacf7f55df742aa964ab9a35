//
//  APIRouter.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    case getStations
 
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getStations:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getStations:
            return "/e7211664-cbb6-4357-9c9d-f12bf8bab2e2"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {

        let result: (path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .getStations:
                return (path, nil)
            }
        }()
        
        // MARK: - Set HTTP Header Field
        let base = URL(string: AppConstants.baseURL)!
        let baseAppend = base.appendingPathComponent(result.path).absoluteString.removingPercentEncoding
        let url = URL(string: baseAppend!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        let encoding = try URLEncoding.default.encode(urlRequest, with: result.parameters)
        return encoding
    }
}
