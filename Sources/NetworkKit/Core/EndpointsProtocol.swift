//
//  EndpointsProtocol.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public protocol EndpointsProtocol:Sendable{
    var baseURL:String? { get }
    var path:String { get }
    var httpMethod:HTTPMethod { get }
    var headers:[String:String]? { get }
    var queryItems:[URLQueryItem]? { get }
    var body:RequestBody? { get }
    var requiredAuth:Bool { get }
}

public enum RequestBody{
    case json (any Encodable & Sendable)
    case raw(Data, contentType: String)
}


public extension EndpointsProtocol{
    var hhtpMethod: HTTPMethod { .get }
    var headers: [String: String]? { [:] }
    var queryItems: [URLQueryItem]? { [] }
    var body: RequestBody? { nil }
    var requiresAuth: Bool { false }
}
