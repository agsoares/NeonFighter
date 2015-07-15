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
    
    var testMenu : UIView!
    
    
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
        if(pauseMenu != nil){
            pauseMenu.removeFromSuperview()
        }
        if(retryMenu != nil){
            retryMenu.removeFromSuperview()
        }
        soundManager.stopMusic();
        hudView.removeFromSuperview()
        let scene = MainMenu(size: self.view!.frame.size)
        let skView = self.view as SKView?
        skView!.presentScene(scene)
    }
    
    func createHudView() {
        hudView = UIView(frame: self.view!.frame)
        var pauseImage = UIImage(named: "btPause")
        let pauseButton = UIButton(image: pauseImage!)
        pauseButton.contentMode = .ScaleAspectFit
        pauseButton.frame.size = CGSizeMake(50/gameManager.scaleFactor, 50/gameManager.scaleFactor)
        pauseButton.addTarget(self,
            action: Selector("touchButton:"),
            forControlEvents: .TouchUpInside)
        pauseButton.tag = 0;
        pauseButton.center.x = CGRectGetMaxX(hudView.frame)-CGRectGetMidX(pauseButton.frame)
        hudView.addSubview(pauseButton);
        
        self.view?.addSubview(hudView);
    }
    
    func createPauseMenu() {
        var menu = NSBundle.mainBundle().loadNibNamed("PauseMenu",
            owner: self,
            options:nil).first as! UIView
        menu.frame = self.view!.frame;
        
        AddCallback(menu)
        
        self.pauseMenu = menu;
    }
    
    
    func createRetryMenu() {
        var menu = NSBundle.mainBundle().loadNibNamed("RetryMenu",
                    owner: self,
                    options:nil).first as! UIView
        menu.frame = self.view!.frame;
        
        AddCallback(menu)
        
        self.retryMenu = menu;
    }
    
    func createMainMenu(){
        self.mainMenu = UIView(frame: CGRectMake(self.frame.width*0.20,
            self.frame.height*0.20,
            self.frame.width*0.60,
            self.frame.height*0.60))
    }
    
    func AddCallback (view: UIView) {
        for v in view.subviews {
            if (v is UIButton) {
                var button = v as! UIButton
                button.addTarget(self,
                    action: Selector("touchButton:"),
                    forControlEvents: .TouchUpInside);
            } else {
                AddCallback(v as! UIView);
            }
            
        }
    
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
                restartScene()
            case 2:
                presentMainMenu()
            case 3:
                pauseMenu.removeFromSuperview()
                view?.paused = false;
            default:
                return;
        }
    }
    
    func restartScene() {
        GameCenterManager.gcManager.reportScore(gameManager.score);
        retryMenu.removeFromSuperview();
        pauseMenu.removeFromSuperview();
        if(NSUserDefaults.standardUserDefaults().integerForKey("BestScore") > gameManager.score){
            NSUserDefaults.standardUserDefaults().setInteger(gameManager.score, forKey: "BestScore");
        }
        gameManager.score = 0;
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
            world.shake(0.1*Float(contact.collisionImpulse/2000.0),
                force: Float(contact.collisionImpulse/2000.0));
        }
        
        if (contact.bodyA.categoryBitMask != PhysicsCategory.Chain &&
            contact.bodyB.categoryBitMask != PhysicsCategory.Chain) {
            if (nodeA!.respondsToSelector("applyDamage:")) {
                var node = nodeA as! DestroyableNode
                node.applyDamage(contact.collisionImpulse);
                if (contact.collisionImpulse >= 2000) {
                    node.sparkle(contact.contactPoint)
                }
            }
            if (nodeB!.respondsToSelector("applyDamage:")) {
                var node = nodeB as! DestroyableNode
                node.applyDamage(contact.collisionImpulse);
                if (contact.collisionImpulse >= 2000) {
                    node.sparkle(contact.contactPoint)
                }
                
            }
            if(GameManager.sharedInstance.userDidEnableSoundFX){
                runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: false))
            }
            
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
        let actualY = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
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
        if (player.life <= 0) {
            presentRetryMenu();
        }
        /* Called before each frame is rendered */
    }
}
