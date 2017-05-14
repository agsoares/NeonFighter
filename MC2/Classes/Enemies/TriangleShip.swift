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
        
        self.size = CGSize(width: 50/gameManager.scaleFactor , height: 50/gameManager.scaleFactor )
        //self.color = UIColor.randColor();
        self.colorBlendFactor = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width*0.45) //(rectangleOfSize: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.restitution = 1
        
        self.physicsBody?.mass = 40
        self.physicsBody?.linearDamping = 0.2;
        self.physicsBody?.angularDamping = 10;

        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(update),
                SKAction.wait(forDuration: 0.01)
                ])
            ))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update();
        let direction = ia.getNormalizedVectorToPlayer(self);
        _ = ia.getAngleToPlayer(self)-self.zRotation;
        physicsBody?.applyAngularImpulse(100)
        //var direction = CGVector(dx: (gameManager.player!.position.x - self.position.x)*100  , dy: (gameManager.player!.position.y - self.position.y)*100);
        physicsBody?.applyForce(CGVector(dx:direction.dx*10000, dy:direction.dy*10000));
    
        
    }
    
    
    
}
