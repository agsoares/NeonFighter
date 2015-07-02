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

    
    var player: Player!;
    var gameManager = GameManager.sharedInstance;
    var soundManager = SoundManager.sharedInstance;
    
    var hudView: UIView!
    
    var mainMenu: UIView!
    var retryMenu: UIView!
    var pauseMenu: UIView!
    
    override func didMoveToView(view: SKView) {
        createPauseMenu()
        createRetryMenu()
        createMainMenu()
        createHudView()
        
        
        self.addChild(world);
        
        self.addChild(hud)
        hud.zPosition = 1.0;
        scoreLabel.text = gameManager.score.description
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-10);
        scoreLabel.verticalAlignmentMode = .Top
        hud.addChild(scoreLabel)
        
        self.backgroundColor = UIColor.wetAsfaltColor()
        
        setupJoystick();
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.1)
        self.physicsWorld.contactDelegate = self;
        

    
        
        startScene();

        if(GameManager.sharedInstance.userDidEnableSound){
            soundManager.playMusic("loop", looped: true);
        }
        
        //self.shader = SKShader(fileNamed: "scanline")//SKShader(source: "test", uniforms: [SKUniform(name: "scale", float: 1.0)])
        //self.shader?.uniforms = [SKUniform(name: "scale", float: 5.0)]
        //self.shouldEnableEffects = true;
        
    }
    
    func presentPauseMenu() {
        self.view?.paused = true;
        self.view?.addSubview(pauseMenu);
    }
    
    
    func presentRetryMenu() {
        self.view?.paused = true;
        self.view?.addSubview(retryMenu);
    }
    
    func presentMainMenu() {
        self.view?.paused = true;
        pauseMenu.removeFromSuperview()
        soundManager.stopMusic();
        hudView.removeFromSuperview()
        let scene = MainMenu(size: self.view!.frame.size)
        let skView = self.view as SKView?
        skView!.presentScene(scene)
    }
    
    func createHudView() {
        hudView = UIView(frame: self.view!.frame)
        var pauseImage = UIImage(named: "btPause")!.imageWithColor(UIColor.pomegranateColor())
        let pauseButton = UIButton(image: pauseImage)
        
//        let pauseButton = UIButton(imageNamed: "btPaused")
        pauseButton.addTarget(self,
            action: Selector("touchButton:"),
            forControlEvents: .TouchUpInside)
        pauseButton.tag = 0;
        pauseButton.center.x = CGRectGetMaxX(hudView.frame)-CGRectGetMidX(pauseButton.frame)
        hudView.addSubview(pauseButton);
        
        self.view?.addSubview(hudView);
    }
    
    func createPauseMenu() {
        let menu = UIView(frame: CGRectMake(self.frame.width*0.20,
            self.frame.height*0.20,
            self.frame.width*0.60,
            self.frame.height*0.60))
        
        self.pauseMenu = menu;
        
        let retryButton = UIButton(imageNamed: "btPlayAgain")
        retryButton.tag = 1;
        retryButton.frame.origin = CGPointMake(menu.frame.width - retryButton.frame.size.width, 0)
        retryButton.addTarget(self,
            action: Selector("touchButton:"),
            forControlEvents: .TouchUpInside);
        
        let backButton = UIButton(imageNamed: "menu")
        backButton.tag = 2;
        backButton.addTarget(self,
            action: Selector("touchButton:"),
            forControlEvents: .TouchUpInside);
        
        let continueButton = UIButton(imageNamed: "btPause")
        continueButton.tag = 3;
        continueButton.frame.origin = CGPointMake(menu.frame.width/2 - continueButton.frame.size.width/2, menu.frame.height/2 - continueButton.frame.size.height/2)
        continueButton.addTarget(self,
            action: Selector("touchButton:"),
            forControlEvents: .TouchUpInside);
//        menu.backgroundColor = UIColor.greenSeaColor()
        menu.addSubview(retryButton);
        menu.addSubview(backButton);
        menu.addSubview(continueButton)
    
    }
    
    func createRetryMenu() {
        var menu = UIView(frame: CGRectMake(self.frame.width*0.20,
            self.frame.height*0.20,
            self.frame.width*0.60,
            self.frame.height*0.60))
        
        self.retryMenu = menu;
        
//        var retryButton = UIButton(frame: CGRectMake(0 , 0, 100, 100))
        let retryImage = UIImage(named: "btPlayAgain");
        let retryButton = UIButton(image: retryImage!)
        
        
        retryButton.contentMode = UIViewContentMode.ScaleAspectFit
        retryButton.setBackgroundImage(retryImage?.imageWithColor(UIColor.pomegranateColor()), forState: UIControlState.Normal)
        retryButton.tag = 1;
        retryButton.addTarget(self,
            action: Selector("touchButton:"),
            forControlEvents: .TouchUpInside);
        menu.addSubview(retryButton);
    
    }
    
    func createMainMenu(){
        self.mainMenu = UIView(frame: CGRectMake(self.frame.width*0.20,
            self.frame.height*0.20,
            self.frame.width*0.60,
            self.frame.height*0.60))
    }
    
    func touchButton(button : UIButton!) {
        switch button.tag {
            case 0:
                if (self.view!.paused && player.life > 0) {
                    self.view?.paused = false;
                    pauseMenu.removeFromSuperview();
                } else {
                    presentPauseMenu()
                }
            case 1:
                restartScene();
            case 2:
                presentMainMenu()
            case 3:
                pauseMenu.removeFromSuperview()
                view?.paused = false;
            
            
            
            default:
                return;
        }
        //restartScene();
        /*
        menuView.removeFromSuperview();
        soundManager.stopMusic();
        let scene = MainMenu(size: self.view!.frame.size)
        let skView = self.view as SKView?
        skView!.presentScene(scene)
        */
    }
    
    func restartScene() {
        GameCenterManager.gcManager.reportScore(gameManager.score);
        retryMenu.removeFromSuperview();
        pauseMenu.removeFromSuperview();
        world.removeAllChildren();
        self.physicsWorld.removeAllJoints();
        self.removeAllActions();
        world.removeAllActions();
        
        view?.paused = false;
        
        startScene();
    }
    
    func startScene() {
        view?.paused = false;
        gameManager.score = 0;
        player = Player();
        var grid = SKSpriteNode(imageNamed: "grid");
        grid.zPosition = -0.1
        grid.size = CGSizeMake(grid.size.width*1.2, grid.size.height*1.2)
        grid.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        grid.blendMode = SKBlendMode.MultiplyX2;
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        world.position = CGPoint(x: 0, y: 0);
        world.addChild(player)
        player.setupPhysics()
        var worldBorder = SKPhysicsBody(edgeLoopFromRect: frame)
        worldBorder.categoryBitMask = PhysicsCategory.Wall;

        world.physicsBody = worldBorder;
        
        world.addChild(grid);
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(5.0),
                SKAction.runBlock(spawnEnemy)
                ])
            ))
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
                    emitter.particleColor = player.ball.color;
                }
                
                world.addChild(emitter);
            
            
                
                if ((contact.bodyA.categoryBitMask & (PhysicsCategory.Enemy | PhysicsCategory.Player)) != 0b0) {
                    println("LOL")
                    
                }
            
            }
            
            
        }
        
        if (contact.bodyA.categoryBitMask != PhysicsCategory.Chain && contact.bodyB.categoryBitMask != PhysicsCategory.Chain) {
            if (nodeA!.respondsToSelector("applyDamage:")) {
                var node = (nodeA as! DestroyableNode);
                node.applyDamage(contact.collisionImpulse)
                if(node.life < 0.0) {
                    node.removeFromParent();
                    if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) {
                        gameManager.score++;
                    } else {
                        presentRetryMenu();
                        return;
                    }
                }

            }
            if (nodeB!.respondsToSelector("applyDamage:")) {
                var node = (nodeB as! DestroyableNode);
                node.applyDamage(contact.collisionImpulse)
                if(node.life < 0.0) {
                    node.removeFromParent();
                    if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) {
                        gameManager.score++;
                    } else {
                        presentRetryMenu();
                        return;
                    }
                }
                if(GameManager.sharedInstance.userDidEnableSoundFX){
                    runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: false))
                }
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
        if (!self.view!.paused) {
          player.physicsBody?.applyForce(CGVectorMake(velocity.x*700, velocity.y*700))
        }
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        scoreLabel.text = gameManager.score.description;
        /* Called before each frame is rendered */
    }
}
