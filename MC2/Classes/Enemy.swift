//
//  Enemy.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit



class Enemy: DestroyableNode {
    var gameManager = GameManager.sharedInstance;
    var ia = IA();
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.randColor(), size: texture.size())
    }
    
    func update() {
        if(self.scene!.frame.contains(self.frame) == true){
            self.physicsBody?.collisionBitMask = PhysicsCategory.All
            self.physicsBody?.contactTestBitMask = PhysicsCategory.All
        }
        if ((self.scene!.frame.maxY <= self.frame.minY  ||
             self.scene!.frame.minY >= self.frame.maxY  ||
             self.scene!.frame.maxX <= self.frame.minX  ||
             self.scene!.frame.minX >= self.frame.maxX) &&
             self.physicsBody?.collisionBitMask == PhysicsCategory.All) {
            
                self.physicsBody?.collisionBitMask = PhysicsCategory.None
                self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
