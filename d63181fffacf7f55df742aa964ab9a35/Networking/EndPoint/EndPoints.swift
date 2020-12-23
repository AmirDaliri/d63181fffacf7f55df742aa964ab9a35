//
//  EndPoints.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum ApiRouter {
    case getStations
}

extension ApiRouter: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://run.mocky.io/v3"
        case .qa: return "https://run.mocky.io/v3"
        case .staging: return "https://run.mocky.io/v3"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    var path: String {
        switch self {
        case .getStations:
            return "/e7211664-cbb6-4357-9c9d-f12bf8bab2e2"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        default:
            return .request
        /// Helper
        /*
        case .<#reqName#>(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "api_key":NetworkManager.APIKey])
        */
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


