//
//  GameScene.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import SpriteKit

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(#min: CGFloat, #max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}



class GameScene: SKScene, AnalogStickProtocol {
    
    let moveAnalogStick: AnalogStick = AnalogStick()
    
    let camera = SKNode();
    let hud = SKNode();
    let world = SKNode();
    
    let player = Player();
    var gameManager = GameManager.sharedInstance;
    
    override func didMoveToView(view: SKView) {
        player.size = CGSizeMake(50, 50)
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(player)
        player.setupPhysics()
        
        
        self.addChild(world);
        self.addChild(hud)
        world.addChild(camera);
        
        setupJoystick();
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.98)
        
        var worldBorder = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody = worldBorder;
    
        runAction(SKAction.repeatActionForever(
        SKAction.sequence([
            SKAction.runBlock(spawnEnemy),
            SKAction.waitForDuration(1.0)
            ])
        ))
                
        self.camera.runAction(SKAction.moveTo(CGPointMake(100, 50), duration: 2.5))

        
        //self.anchorPoint = CGPointMake(0.5, 0.5);
        
    }
    
    func setupJoystick() {
        let bgDiametr: CGFloat = 120
        let thumbDiametr: CGFloat = 60
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.delegate = self
        moveAnalogStick.hidden = true
        moveAnalogStick.alpha = 0.25
        moveAnalogStick.position = CGPointMake(-100, -100)
        hud.addChild(moveAnalogStick)
    
    }
    
    func spawnEnemy() {
        let enemy = TriangleShip()
        // Determine where to spawn the enemy along the Y axis
        let actualY = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
        
        // Position the enemy slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: actualY)
        
        addChild(enemy)
    
    }
 
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)

        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            moveAnalogStick.position = location
            moveAnalogStick.hidden = false
        }
        moveAnalogStick.touchesBegan(touches, withEvent: event)
        moveAnalogStick.touchesMoved(touches, withEvent: event)

    }
   
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        moveAnalogStick.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        moveAnalogStick.touchesEnded(touches, withEvent: event)
        moveAnalogStick.position = CGPointMake(-100, -100)
        moveAnalogStick.hidden = true
        
    }
    
    override func didSimulatePhysics() {
        //centerOnNode(player);
    }
    
    func centerOnNode(node: SKNode) {
        let cameraPositionInScene: CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!)
        node.parent!.position = CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y: node.parent!.position.y - cameraPositionInScene.y)
    }
    
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        player.physicsBody?.applyForce(CGVectorMake(velocity.x*5000, velocity.y*5000))
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
