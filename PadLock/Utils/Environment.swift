//
//  Environment.swift
//  PadLock
//
//  Created by Alex Albu on 13.05.2023.
//

import Foundation

struct Environment {
    static var local: String {
        "http://localhost:3000"
    }
    
    static var production: String {
        "https://yonder-hackathon-2023.azurewebsites.net"
    }
}
