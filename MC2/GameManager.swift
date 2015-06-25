//
//  GameManager.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Enemy     : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

class GameManager {
    var player: Player?
    var score = 0;
    
    
    static let sharedInstance = GameManager()
}
