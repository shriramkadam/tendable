//
//  UrlManager.swift
//  TendableService
//
//  Created by Shriram Kadam on 15/06/24.
//

import Foundation

struct UrlManager {
    
    static var baseUrlApi: String {
        #if DEBUG
            return "http://localhost:5001/api/" // For development
        #else
            return "http://127.0.0.1:5001/api/"  // For Production
        #endif
    }
    
}
