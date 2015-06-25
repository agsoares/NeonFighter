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
        
        self.size = CGSizeMake(50, 50)
        self.color = UIColor.greenColor()
        self.colorBlendFactor = 1
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        //self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        self.physicsBody?.mass = 100
        
        
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(update),
                SKAction.waitForDuration(0.2)
                ])
            ))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if(self.scene!.frame.contains(self.position) == true){
            self.physicsBody?.collisionBitMask = PhysicsCategory.All
        }
        var direction = CGVector(dx: (gameManager.player!.position.x - self.position.x)*3000  , dy: (gameManager.player!.position.y - self.position.y)*3000);
        println(direction.dx.description + " " + direction.dy.description)
        physicsBody?.applyForce(direction);
    
    }
    
    
    
}
