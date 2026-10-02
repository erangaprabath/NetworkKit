//
//  AuthTokenProvider.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-10-02.
//

import Foundation

public protocol AuthTokenProvider:Sendable{
    func authorizationHeader() async throws -> (key:String,value:String)
    
}
