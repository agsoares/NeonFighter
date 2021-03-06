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

class GameScene: SKScene, AnalogStickProtocol, SKPhysicsContactDelegate, UnityAdsDelegate {
    
    let moveAnalogStick: AnalogStick = AnalogStick()
    
    //let camera = SKNode();
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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        createPauseMenu()
        createRetryMenu()
        createHudView()
        
        
        self.addChild(world);
        
        self.addChild(hud)
        hud.zPosition = 1.0;
        scoreLabel.text = gameManager.score.description
        scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY-10);
        scoreLabel.verticalAlignmentMode = .top
        hud.addChild(scoreLabel)
        
        self.backgroundColor = UIColor.wetAsfaltColor()
        
        setupJoystick();
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.1)
        self.physicsWorld.contactDelegate = self;
        startScene();

        if(GameManager.sharedInstance.userDidEnableSound){
            soundManager.playMusic("loop", looped: true);
        }
        
        UnityAds.sharedInstance().delegate = self
    }
    
    func presentPauseMenu() {
        self.view?.isPaused = true;
        self.view?.addSubview(pauseMenu);
        self.view?.bringSubview(toFront: hudView);
    }
    
    
    func presentRetryMenu() {
        self.view?.isPaused = true;
        self.view?.addSubview(retryMenu);
        
    }
    
    func unityAdsVideoCompleted(_ rewardItemKey : String, skipped : Bool) {
        UnityAds.sharedInstance().hide()
    }
    
    func presentMainMenu() {
        if let view = self.view {
            view.isPaused = false;
            pauseMenu.removeFromSuperview()
            retryMenu.removeFromSuperview()
            soundManager.stopMusic();
            hudView.removeFromSuperview()
            let scene = MainMenu(size: view.frame.size)
            if let skView = self.view as SKView? {
                skView.presentScene(scene)
            }
        }

    }
    
    func createHudView() {
        hudView = UIView(frame: CGRect(x: 0, y: 0,
            width: self.view!.frame.size.width, height: self.view!.frame.size.height/2))
        let pauseImage = UIImage(named: "btPause")
        let pauseButton = UIButton(image: pauseImage!)
        pauseButton.contentMode = .scaleAspectFit
        pauseButton.frame.size = CGSize(width: 50/gameManager.scaleFactor, height: 50/gameManager.scaleFactor)
        pauseButton.tag = 0;
        pauseButton.center.x = hudView.frame.maxX-pauseButton.frame.midX
        hudView.addSubview(pauseButton);
        hudView.addCallback(self, callback: Selector("touchButton:"))
        
        self.view?.addSubview(hudView);
    }
    
    func createPauseMenu() {
        let menu = Bundle.main.loadNibNamed("PauseMenu",
            owner: self,
            options:nil)?.first as! UIView
        menu.frame = self.view!.frame;
        
        menu.addCallback(self, callback: Selector("touchButton:"))
        
        self.pauseMenu = menu;
    }
    
    
    func createRetryMenu() {
        let menu = Bundle.main.loadNibNamed("RetryMenu",
                    owner: self,
                    options:nil)?.first as! UIView
        menu.frame = self.view!.frame;
        
        menu.addCallback(self, callback: Selector("touchButton:"))
        
        self.retryMenu = menu;
    }
    
    func AddCallback (_ view: UIView) {
        for v in view.subviews {
            if (v is UIButton) {
                let button = v as! UIButton
                button.addTarget(self,
                    action: #selector(GameScene.touchButton(_:)),
                    for: .touchUpInside);
            } else {
                AddCallback(v );
            }
            
        }
    
    }
    
    func touchButton(_ button : UIButton!) {
        if let view = self.view {
            switch button.tag {
            case 0:
                if (view.isPaused && player.life > 0) {
                    view.isPaused = false;
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
                view.isPaused = false;
            default:
                return;
            }
        }

    }
    
    func restartScene() {
        GameCenterManager.gcManager.reportScore(gameManager.score);
        retryMenu.removeFromSuperview();
        pauseMenu.removeFromSuperview();
        if(UserDefaults.standard.integer(forKey: "BestScore") > gameManager.score){
            UserDefaults.standard.set(gameManager.score, forKey: "BestScore");
        }
        gameManager.score = 0;
        world.removeAllChildren();
        self.physicsWorld.removeAllJoints();
        self.removeAllActions();
        world.removeAllActions();
        
        view?.isPaused = false;
        
        startScene();
    }
    
    func startScene() {
        view?.isPaused = false;
        gameManager.score = 0;
        player = Player();
        let grid = SKSpriteNode(imageNamed: "grid");
        grid.zPosition = -0.1
        grid.size = CGSize(width: grid.size.width*1.2, height: grid.size.height*1.2)
        grid.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        grid.blendMode = SKBlendMode.multiplyX2;
        player.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        world.position = CGPoint(x: 0.5, y: 0.5);
        world.addChild(player)
        player.setupPhysics()
        let worldBorder = SKPhysicsBody(edgeLoopFrom: frame)
        worldBorder.categoryBitMask = PhysicsCategory.Wall;

        world.physicsBody = worldBorder;
        
        world.addChild(grid);
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 5.0),
                SKAction.run(spawnEnemy)
                ])
            ))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node;
        let nodeB = contact.bodyB.node;

        if(contact.collisionImpulse >= 2000) {
            world.shake(0.1*Float(contact.collisionImpulse/2000.0),
                force: Float(contact.collisionImpulse/2000.0));
        }
        
        if (contact.bodyA.categoryBitMask != PhysicsCategory.Chain &&
            contact.bodyB.categoryBitMask != PhysicsCategory.Chain) {
            if (nodeA!.responds(to: "applyDamage:")) {
                let node = nodeA as! DestroyableNode
                if (contact.collisionImpulse >= 2000) {
                    node.sparkle(contact.contactPoint)
                }
                node.applyDamage(contact.collisionImpulse);

            }
            if (nodeB!.responds(to: "applyDamage:")) {
                let node = nodeB as! DestroyableNode
                if (contact.collisionImpulse >= 2000) {
                    node.sparkle(contact.contactPoint)
                }
                node.applyDamage(contact.collisionImpulse);

                
            }
            if(GameManager.sharedInstance.userDidEnableSoundFX){
                run(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: false))
            }
            
        }
    }
    func setupJoystick() {
        let bgDiametr: CGFloat = 120
        let thumbDiametr: CGFloat = 60
        moveAnalogStick.bgNodeDiametr = bgDiametr
        moveAnalogStick.thumbNodeDiametr = thumbDiametr
        moveAnalogStick.delegate = self
        moveAnalogStick.isHidden = true
        moveAnalogStick.alpha = 0.25
        moveAnalogStick.position = CGPoint(x: -100, y: -100)
        hud.addChild(moveAnalogStick)
    
    }
    
    func spawnEnemy() {
        let enemy = TriangleShip()
        let actualY = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: actualY)
        
        world.addChild(enemy)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        super.touchesBegan(touches, with: event)

        for touch in (touches ) {
            let location = touch.location(in: self)
            moveAnalogStick.position = location
            moveAnalogStick.isHidden = false
        }
        moveAnalogStick.touchesBegan(touches, with: event)
        moveAnalogStick.touchesMoved(touches, with: event)

    }
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        moveAnalogStick.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        moveAnalogStick.touchesEnded(touches, with: event)
        moveAnalogStick.position = CGPoint(x: -100, y: -100)
        moveAnalogStick.isHidden = true
        
    }
    
    func centerOnNode(_ node: SKNode) {
        let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: node.parent!)
        node.parent!.position = CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y: node.parent!.position.y - cameraPositionInScene.y)
    }
    
    func moveAnalogStick(_ analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float) {
        if (!self.view!.isPaused) {
          player.physicsBody?.applyForce(CGVector(dx: velocity.x*700, dy: velocity.y*700))
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        scoreLabel.text = gameManager.score.description;
        if (player.life <= 0) {
            gameManager.deathCount+1;
//            UnityAds.sharedInstance().setZone("defaultZone")
//            
//            if (UnityAds.sharedInstance().isDebugMode() ||
//                    (UnityAds.sharedInstance().canShow() && gameManager.deathCount <= 0)) {
//                gameManager.deathCount = 0;
//                UnityAds.sharedInstance().show()
//                if let musicPlayer = soundManager.player {
//                    musicPlayer.volume = 0;
//                }
//            }
            
            presentRetryMenu();
        }
        /* Called before each frame is rendered */
    }
}
