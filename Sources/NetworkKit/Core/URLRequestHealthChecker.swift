//
//  URLRequestHealthChecker.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-30.
//
import Foundation

final class URLRequestHealthChecker:Sendable{
    
    func checkAllowForRetryByHttpMethod (_ request:URLRequest) -> Bool{
        let allowMethods = ["GET","PUT","DELETE"]
        return allowMethods.contains(request.httpMethod ?? "")
    }
}
