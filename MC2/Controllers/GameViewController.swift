//
//  GameViewController.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController /*, UnityAdsDelegate */ {
    var gameManager = GameManager.sharedInstance;
    var soundManager = SoundManager.sharedInstance;
    
    func callGameCenter(sender: NSNotification?) {
        GameCenterManager.gcManager.showLeaderBoards(self);
    }
    
    override func viewDidLoad() {
        GameCenterManager.gcManager.authenticateLocalPlayer(self);
        
        //UnityAds.sharedInstance().delegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "callGameCenter:",
            name: "callGameCenterLeaderBoard",
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
        scene.scaleMode = .AspectFill
        
        skView.presentScene(menu)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func unityAdsWillShow() {
    }
    
    func unityAdsWillLeaveApplication() {
        
    }
    
    
    func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool) {
        if let musicPlayer = soundManager.player {
            musicPlayer.volume = 1;
        }
    }
}
