//
//  NetworkManagerProtocol.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//


public protocol NetworkManagerProtocol:Sendable {
    func dataFetch<T:Decodable> (_ endpoint:any EndpointsProtocol) async throws -> T
}
