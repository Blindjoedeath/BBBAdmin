//
//  Settings+Decodable.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 13.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

struct SettingsParsed {
    
    var bassLevel: Float
    var boostLevel: Float
    
    init(bassLevel: Float, boostLevel: Float){
        self.bassLevel = bassLevel
        self.boostLevel = boostLevel
    }
    
}

extension SettingsParsed : Decodable{
    
    enum CodingKeys : String, CodingKey {
        case boostLevel = "BoostLevel"
        case bassLevel = "BassLevel"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let boostLevel = try! container.decode(Float.self, forKey: .boostLevel)
        let bassLevel = try! container.decode(Float.self, forKey: .bassLevel)
        
        self.init(bassLevel: bassLevel, boostLevel: boostLevel)
    }
}
