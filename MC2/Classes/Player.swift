//
//  Player.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit

class Player: DestroyableNode {
    var ball: SKSpriteNode!
    
    init() {
        let texture = SKTexture(imageNamed: "player2")
        super.init(texture: texture, color: UIColor.greenSeaColor(),
            size: texture.size())
        self.size = CGSizeMake(50/gameManager.scaleFactor, 50/gameManager.scaleFactor)
        maxLife *= 4;
        life *= 4;
        self.zPosition = 0.5
        
        gameManager.player = self;

    }

    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width/2)*0.6)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.angularDamping = 0.9
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.All
        self.physicsBody?.contactTestBitMask = PhysicsCategory.All

        
        ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSizeMake(50/gameManager.scaleFactor , 50/gameManager.scaleFactor )
        ball.color = UIColor.redColor();
        ball.colorBlendFactor = 1
        
        let rope = Rope()
        rope.zPosition = 0.1;
        //rope.physicsWorld = self.physicsWorld
        self.addChild(rope)
        
        rope.setAttachmentPoint(CGPointMake(self.position.x, self.frame.midY), toNode: self)
        rope.attachObject(ball)
        rope.setRopeLenght(Int(floor(20/gameManager.scaleFactor)), withImageNamed: "rope_ring")
        
        
        self.physicsBody?.mass = 30
        self.physicsBody?.angularDamping = 0;
        
        ball.physicsBody?.mass = 30
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Weapon
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.All
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}