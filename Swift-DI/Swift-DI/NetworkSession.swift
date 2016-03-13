//
//  NetworkSession.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 12.03.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Foundation

@objc
protocol NetworkSession {
    func request(baseURL: NSURL, path: String) -> NSURLRequest
}

extension NSURLSession: NetworkSession {
    func request(baseURL: NSURL, path: String) -> NSURLRequest {
        return NSURLRequest(URL: baseURL.URLByAppendingPathComponent(path))
    }
}
