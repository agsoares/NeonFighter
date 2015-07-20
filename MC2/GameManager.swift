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
    static let Player    : UInt32 = 0b1 << 0
    static let Weapon    : UInt32 = 0b1 << 1
    static let Enemy     : UInt32 = 0b1 << 2
    static let Projectile: UInt32 = 0b1 << 3
    static let Chain     : UInt32 = 0b1 << 4
    static let Wall      : UInt32 = 0b1 << 5
    
    static let All       : UInt32 = UInt32.max

    
}

class GameManager {
    var player: Player?
    var score = 0;
    var difficult = 1;
    var userDidEnableSound = true;
    var userDidEnableSoundFX = true;

    var deathCount = 0;
    
    var scaleFactor: CGFloat = 1.0;
    
    static let sharedInstance = GameManager()
    
    
}
