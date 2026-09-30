//
//  NetworkLogger.swift
//  NetworkLayer
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public final class NetworkLogger:Sendable{
    
    public init () {}
    
    func logRequest(_ request:URLRequest) {
#if DEBUG
        print("_____________________")
        print("REQUEST")
        print("URL   : \(request.url?.absoluteString ?? "No url found")")
        print("Mthod : \(request.httpMethod ?? "No method found")")
        
        if var headers = request.allHTTPHeaderFields,!headers.isEmpty{
            headers.removeValue(forKey: "Authorization")
            print("Headers  : \(headers)")
        }
        if let body = request.httpBody,!body.isEmpty{
            print("Body   : \(body)")
        }
        
        print("_____________________")
        
#endif
    }

    
    
    func logResponse(_ response:HTTPURLResponse,data:Data) {
        #if DEBUG
        print("_____________________")
        print("RESPONSE")
        print("URL     : \(response.url?.absoluteString ?? "No url found")")
        print("Status  : \(response.statusCode)")
        if let responseString = String(data:data,encoding:.utf8){
            print("Body  : \(responseString)")
        }
        print("_____________________")
        
        #endif
    }
    
    func logError(_ error:Error,request:URLRequest){
        #if DEBUG
        print("*****************")
        print("ERROR")
        print("URL  : \(request.url?.absoluteString ?? "No url found")")
        print("Info : \(error.localizedDescription)")
        print("*****************")
        
        #endif
    }
    
    func cacheMemoryStatus (_ urlCache:URLCache) {
        print("<><><><><><><><>")
        print("Current memory usage : \(urlCache.currentMemoryUsage) / \(urlCache.memoryCapacity)")
        print("Current disk usage : \(urlCache.currentDiskUsage) / \(urlCache.diskCapacity)")
    }
}
