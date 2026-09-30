//
//  EndpointsProtocol.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public protocol EndpointsProtocol{
    var baseURL:String? { get }
    var path:String { get }
    var httpMethod:HTTPMethod { get }
    var header:[String:String]? { get }
    var queryItems:[String:String]? { get }
    var body:(any Encodable & Sendable)? { get }
    var isAuthTokenRequired:Bool { get }
    var authToken:(key:String,value:String)? { get }
    var publickKey:String? { get }
    var privateKey:String? { get }
    var rawBody:Data? { get }
}
