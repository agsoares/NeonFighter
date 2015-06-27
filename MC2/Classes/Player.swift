//
//  Player.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit

class Player: SKSpriteNode {
    var gameManager = GameManager.sharedInstance;
    
    
    init() {
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: UIColor.whiteColor(), size: CGSizeMake(50, 50))
        gameManager.player = self;

    }

    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.All
        self.physicsBody?.contactTestBitMask = PhysicsCategory.All

        
        var ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSizeMake(50, 50)
        ball.color = UIColor.redColor();
        ball.colorBlendFactor = 1
        
        var rope = Rope()
        //rope.physicsWorld = self.physicsWorld
        self.addChild(rope)
        
        rope.setAttachmentPoint(CGPointMake(self.position.x, self.frame.midY), toNode: self)
        rope.attachObject(ball)
        rope.setRopeLenght(20, withImageNamed: "rope_ring")
        
        
        self.physicsBody?.mass = 30
        self.physicsBody?.angularDamping = 0;
        
        ball.physicsBody?.mass = 50
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Weapon
        ball.physicsBody?.collisionBitMask = PhysicsCategory.All
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}