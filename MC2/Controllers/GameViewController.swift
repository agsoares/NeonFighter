//
//  GameViewController.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var gameManager = GameManager.sharedInstance;
    var soundManager = SoundManager.sharedInstance;
    
    func callGameCenter(_ sender: Notification?) {
        GameCenterManager.gcManager.showLeaderBoards(self);
    }
    
    override func viewDidLoad() {
        GameCenterManager.gcManager.authenticateLocalPlayer(self);
        
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(GameViewController.callGameCenter(_:)),
            name: NSNotification.Name(rawValue: "callGameCenterLeaderBoard"),
            object: nil);
        
        super.viewDidLoad()
        let xScaleFactor = 1024.0/self.view.frame.size.width
        let yScaleFactor = 768.0/self.view.frame.size.height
        gameManager.scaleFactor = (xScaleFactor <= yScaleFactor) ? xScaleFactor : yScaleFactor;
        
        let scene = GameScene(size: self.view.frame.size)
        
        

        let menu = MainMenu(size: self.view.frame.size)
        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        scene.backgroundColor = UIColor.wetAsfaltColor()
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(menu)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func unityAdsWillShow() {
    }
    
    func unityAdsWillLeaveApplication() {
        
    }
    
    
    func unityAdsVideoCompleted(_ rewardItemKey: String!, skipped: Bool) {
        if let musicPlayer = soundManager.player {
            musicPlayer.volume = 1;
        }
    }
}
