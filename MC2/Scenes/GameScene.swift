//
//  GameScene.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import SpriteKit
import AudioToolbox

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



class GameScene: SKScene, AnalogStickProtocol, SKPhysicsContactDelegate {
    
    let moveAnalogStick: AnalogStick = AnalogStick()
    
    let camera = SKNode();
    let hud = SKNode();
    let world = SKNode();
    var scoreLabel = SKLabelNode(fontNamed: "Icklips")

    
    let player = Player();
    var gameManager = GameManager.sharedInstance;
    var soundManager = SoundManager.sharedInstance;
    
    override func didMoveToView(view: SKView) {
        self.addChild(world);
        var grid = SKSpriteNode(imageNamed: "grid");
        grid.zPosition = -0.1
        grid.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        grid.blendMode = SKBlendMode.MultiplyX2;
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        world.addChild(player)
        player.setupPhysics()
        
        self.addChild(hud)
        hud.zPosition = 1.0;
        scoreLabel.text = gameManager.score.description
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-10);
        scoreLabel.verticalAlignmentMode = .Top
        hud.addChild(scoreLabel)
        
        
        world.addChild(grid);
        
        setupJoystick();
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.1)
        self.physicsWorld.contactDelegate = self;
        
        var worldBorder = SKPhysicsBody(edgeLoopFromRect: frame)
        //worldBorder.usesPreciseCollisionDetection = true;
        world.physicsBody = worldBorder;
    
        runAction(SKAction.repeatActionForever(
        SKAction.sequence([
            SKAction.waitForDuration(5.0),
            SKAction.runBlock(spawnEnemy)
            ])
        ))
                
        self.camera.runAction(SKAction.moveTo(CGPointMake(100, 50), duration: 2.5))

        
        //self.shader = SKShader(fileNamed: "scanline")//SKShader(source: "test", uniforms: [SKUniform(name: "scale", float: 1.0)])
        //self.shader?.uniforms = [SKUniform(name: "scale", float: 5.0)]
        //self.shouldEnableEffects = true;
        
        
        soundManager.playMusic("TestMP3", looped: true);
        
        
        
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var nodeA = contact.bodyA.node;
        var nodeB = contact.bodyB.node;



        if(contact.collisionImpulse >= 2000) {
            world.shake(0.1*Float(contact.collisionImpulse/2000.0), force: Float(contact.collisionImpulse/2000.0));
            
            var sparkles = SKTexture(imageNamed: "rope_ring") //reusing the bird texture for now
            if (contact.bodyA.categoryBitMask != PhysicsCategory.Chain && contact.bodyB.categoryBitMask != PhysicsCategory.Chain) {
                var emitter = SKEmitterNode()
                emitter.particleTexture = sparkles
                emitter.position = contact.contactPoint
                emitter.particleBirthRate = 450
                emitter.numParticlesToEmit = 50
                emitter.emissionAngleRange = 360
                emitter.particleLifetime = 1
                emitter.particleSpeed = 50.0
                emitter.particleSpeedRange = 50;
                emitter.xAcceleration = 0
                emitter.yAcceleration = -40
                if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy || contact.bodyB.categoryBitMask == PhysicsCategory.Enemy ) {
                    emitter.particleColorBlendFactor = 1

                    if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) {
                        emitter.particleColor = (contact.bodyA.node as! SKSpriteNode).color
                    } else {
                        emitter.particleColor = (contact.bodyB.node as! SKSpriteNode).color
                    }
                } else if (contact.bodyA.categoryBitMask == PhysicsCategory.Weapon || contact.bodyB.categoryBitMask == PhysicsCategory.Weapon ) {
                    emitter.particleColorBlendFactor = 1
                    emitter.particleColor = player.ball.color
                
                
                }
                
                world.addChild(emitter);
            }
        }
        
        if (contact.collisionImpulse >= 20000) {
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) {
                (contact.bodyA.node as! SKSpriteNode).removeFromParent();
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                gameManager.score++;
            }
            if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) {
                (contact.bodyB.node as! SKSpriteNode).removeFromParent();
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                gameManager.score++;
            }
        }
        
        if(contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) {
            println("eita")
        }
        
        if(contact.bodyA.categoryBitMask == PhysicsCategory.Enemy && contact.bodyB.categoryBitMask == PhysicsCategory.Player) {
            //println(contact.collisionImpulse);
            
        }
        
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
        
        world.addChild(enemy)
    
        //world.shake(1.0)
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
        player.physicsBody?.applyForce(CGVectorMake(velocity.x*700, velocity.y*700))
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        scoreLabel.text = gameManager.score.description;
        /* Called before each frame is rendered */
    }
}
