//
//  GameViewController.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}



class GameViewController: UIViewController {
    var gameManager = GameManager.sharedInstance;
    
    override func viewDidLoad() {
        
        GameCenterManager.gcManager.authenticateLocalPlayer(self);
        
        super.viewDidLoad()
        var xScaleFactor = 1024.0/self.view.frame.size.width
        var yScaleFactor = 768.0/self.view.frame.size.height
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

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
