//
//  APIClientImp.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Foundation

class APIClientImp: NSObject, APIClient {
    
    let baseURL: NSURL
    let session: NetworkSession
    
    var logger: Logger?
    
    init(baseURL: NSURL, session: NetworkSession) {
        self.baseURL = baseURL
        self.session = session
    }

    func get(path: String) {
        let request = session.request(baseURL, path: path)
        let message = "GET \(request)"
        logger?.log(message)
    }
}
