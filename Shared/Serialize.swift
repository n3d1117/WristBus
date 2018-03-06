//
//  Serialize.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import Foundation
import CryptoSwift

class Serialize {
    
    static func calculateNormalizedTimeFromBegin() -> Int {
        let a = NSDate().timeIntervalSince1970 / 900
        return Int(round(a)) * 900
    }
    
    static func getDynamicPassword(a: String) -> String {
        let b = String(calculateNormalizedTimeFromBegin()) + a
        return b.sha1()
    }
    
}
