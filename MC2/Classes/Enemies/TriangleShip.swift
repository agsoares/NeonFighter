//
//  TriangleShip.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit

class TriangleShip: Enemy {
    init() {
        super.init(imageNamed: "triangle_ship")
        
        self.size = CGSizeMake(50/gameManager.scaleFactor , 50/gameManager.scaleFactor )
        self.color = UIColor.randColor();
        self.colorBlendFactor = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width*0.45) //(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.restitution = 0.5
        
        self.physicsBody?.mass = 40
        
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(update),
                SKAction.waitForDuration(0.1)
                ])
            ))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update();
        var direction = CGVector(dx: (gameManager.player!.position.x - self.position.x)*100  , dy: (gameManager.player!.position.y - self.position.y)*100);
        physicsBody?.applyForce(direction);
    
        
    }
    
    
    
}
