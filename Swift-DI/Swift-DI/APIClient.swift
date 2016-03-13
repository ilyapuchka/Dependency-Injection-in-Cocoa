//
//  APIClient.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

protocol APIClient {
    func get(path: String)
    var logger: Logger? { get set }
}
