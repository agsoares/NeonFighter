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
        //self.color = UIColor.randColor();
        self.colorBlendFactor = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width*0.45) //(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.restitution = 1
        
        self.physicsBody?.mass = 40
        self.physicsBody?.linearDamping = 0.2;
        self.physicsBody?.angularDamping = 10;

        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(update),
                SKAction.waitForDuration(0.01)
                ])
            ))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update();
        var direction = ia.getNormalizedVectorToPlayer(self);
        var angle = ia.getAngleToPlayer(self)-self.zRotation;
        physicsBody?.applyAngularImpulse(100)
        //var direction = CGVector(dx: (gameManager.player!.position.x - self.position.x)*100  , dy: (gameManager.player!.position.y - self.position.y)*100);
        physicsBody?.applyForce(CGVector(dx:direction.dx*10000, dy:direction.dy*10000));
    
        
    }
    
    
    
}
