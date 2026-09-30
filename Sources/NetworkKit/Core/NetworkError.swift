//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public enum NetworkError:Error,LocalizedError{
    case invalidResponse
    case invalidStatusCode(statusCode:Int)
    case decodingFailed(Error)
    case nocache
    case unknown(error:Error)
    case cancelled
    case timeOut
    case retryFailed
    case noInternet
    case unAuthorized
}
