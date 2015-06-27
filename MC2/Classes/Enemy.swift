//
//  Enemy.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit



class Enemy: SKSpriteNode {
    var gameManager = GameManager.sharedInstance;
    var resistance = 0;
    var life = 0;
    var mass = 0;
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
