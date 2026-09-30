//
//  CheckResponseStatus.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

final class CheckResponseStatus{
    
    
     func check500StatusCode(from httpResponse:HTTPURLResponse) throws -> Bool{
        return (500...599).contains(httpResponse.statusCode)
    }
    
     func checkStatusCode(from httpResponse:HTTPURLResponse) throws -> Bool{
        return (200...299).contains(httpResponse.statusCode)
    }
    
     func checkUnAuthorizedStatusCode(from httpResponse:HTTPURLResponse) throws -> Bool{
        return ![401,402,400].contains(httpResponse.statusCode)
    }
}
