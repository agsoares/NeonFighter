//
//  GameScene.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, AnalogStickProtocol {
    
    let moveAnalogStick: AnalogStick = AnalogStick()
    
    let camera = SKNode();
    let hud = SKNode();
    let world = SKNode();
    
    let player = SKSpriteNode(imageNamed: "Ball")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.addChild(world);
        world.addChild(camera);
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.98)
        
        let bgDiametr: CGFloat = 120
        let thumbDiametr: CGFloat = 60
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.delegate = self
        moveAnalogStick.hidden = true
        moveAnalogStick.alpha = 0.25
        moveAnalogStick.position = CGPointMake(-100, -100)
        world.addChild(moveAnalogStick)
        
        player.size = CGSizeMake(50, 50)
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = true
        
        player.zPosition = 0.1

        
        world.addChild(player)
        
        
        var ball = SKSpriteNode(imageNamed: "001")
        ball.size = CGSizeMake(50, 50)
        ball.color = UIColor.redColor()
        ball.colorBlendFactor = 1

        
        var rope = Rope()
        world.addChild(rope)
        
        //CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        rope.setAttachmentPoint(CGPointMake(player.position.x, player.frame.midY), toNode: player)
        rope.attachObject(ball)
        rope.setRopeLenght(25, withImageNamed: "corrente2")


        player.physicsBody?.mass = 300
        player.physicsBody?.angularDamping = 0;
        ball.physicsBody?.mass = 300
        
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
    
    override func didFinishUpdate() {
        centerOnNode(camera);
    }
    
    func centerOnNode(node :SKNode){
        
        var cameraPositionInScene = node.convertPoint(node.position, fromNode: node.parent!);
        node.parent?.position = CGPointMake(node.parent!.position.x - cameraPositionInScene.x, node.parent!.position.y - cameraPositionInScene.y)
    }
    
    func moveAnalogStick(analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        player.physicsBody?.applyForce(CGVectorMake(velocity.x*5000, velocity.y*5000))
        
        centerOnNode(player);
        
//        if( player.position.x > camera.frame.maxX - 50 ){//self.frame.maxX - 50){
//            camera.position.x = camera.position.x + 10
//        }
//        if(self.player.position.x < camera.frame.minX + 50){ //self.frame.minX + 50){
//            camera.position.x = camera.position.x - 10
//        }
//        if(self.player.position.y > camera.frame.maxY - 50 ){ //self.frame.maxY - 50){
//            camera.position.y = camera.position.y + 10
//        }
//        if(self.player.position.y < camera.frame.minY + 50){//self.frame.minY + 50){
//            camera.position.y = camera.position.y - 10
//        }

    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
