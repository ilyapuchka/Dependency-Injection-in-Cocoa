//
//  ConsoleLogger.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Foundation

class ConsoleLogger: NSObject, Logger {
    func log(message: String) {
        print("[\(self.dynamicType) <\(unsafeAddressOf(self))>]: \(message)")
    }
}
