//
//  MainMenu.swift
//  MC2
//
//  Created by Marcus Vinicius Kuquert on 29/06/15.
//
//
import SpriteKit

class MainMenu: SKScene {
//    func createButtonWithImageNamed(imageName: String) -> UIButton{
//        let button = UIButton()
//        
//        if let image = UIImage(named: imageName){
//            button.frame.size = image.size / GameManager.sharedInstance.scaleFactor
//            button.frame.origin = CGPointMake(0, 0)
//            button.setImage(image, forState: .Normal)
//        }else{
//            button.frame = CGRectMake(0, 0, 80, 80)
//            button.backgroundColor = .redColor()
//        }
//        button.addTarget(self,
//            action: "buttonPressed:",
//            forControlEvents: .TouchUpInside)
//        return button
//    }
//    
//    func createButtonWithTwoStatesAndImageNamed(enableImageName: String, selectedImageName: String) -> UIButton{
//        let button = createButtonWithImageNamed(enableImageName)
//        button.setImage(UIImage(named: selectedImageName), forState: UIControlState.Selected)
//        return button
//    }
    
    
    override func didMoveToView(view: SKView) {
        GameManager.sharedInstance.userDidEnableSoundFX = NSUserDefaults.standardUserDefaults().boolForKey("userDidEnableSoundFX")
        GameManager.sharedInstance.userDidEnableSound = NSUserDefaults.standardUserDefaults().boolForKey("userDidEnableSound")
        
        
        println("\(GameManager.sharedInstance.userDidEnableSoundFX)")
        println("\(GameManager.sharedInstance.userDidEnableSound)")
        let viewSize = self.view?.frame.size
        
        let playButton = UIButton(imageNamed: "btPlayGame")
        
        let muteFXButton = UIButton(enableImageName: "btSomOn", selectedImageName: "btSomOff")
        let muteButton =  UIButton(enableImageName: "btSomOn", selectedImageName: "btSomOff")
//        let muteButton = createButtonWithImageNamed("btVolume3")
        
        playButton.addTarget(self,
            action: "buttonPressed:",
            forControlEvents: .TouchUpInside)
        muteFXButton.addTarget(self,
            action: "buttonPressed:",
            forControlEvents: .TouchUpInside)
        muteButton.addTarget(self,
            action: "buttonPressed:",
            forControlEvents: .TouchUpInside)
        
        playButton.tag = 1
        muteButton.tag = 2
        muteFXButton.tag = 3
//        bt.tag = 4
        
        
        
        playButton.frame.origin = CGPointMake(
            (viewSize?.width)!/2 - playButton.frame.size.width/2,
            (viewSize?.height)!/2 - playButton.frame.size.height/2)
        
        muteFXButton.frame.origin = CGPointMake(muteButton.frame.size.width, 0)
        
        muteFXButton.selected = !GameManager.sharedInstance.userDidEnableSoundFX
        muteButton.selected = !GameManager.sharedInstance.userDidEnableSound
        
        self.view?.addSubview(playButton);
        self.view?.addSubview(muteButton);
        self.view?.addSubview(muteFXButton);
    }
    
    func buttonPressed(sender: UIButton){
        switch sender.tag{
        case 1:
            let scene = GameScene(size: self.view!.frame.size)
            let skView = self.view as SKView?
            scene.scaleMode = .AspectFill
            
            //Remove all UIBUttons from self.view
            for subview in self.view?.subviews as! [UIView]{
                if let button = subview as? UIButton{
                    button.removeFromSuperview()
                }
            }
            skView!.presentScene(scene)
            break
        case 2:
            sender.selected = !sender.selected
            GameManager.sharedInstance.userDidEnableSound = !sender.selected
            break
        case 3:
            sender.selected = !sender.selected
            GameManager.sharedInstance.userDidEnableSoundFX = !sender.selected
        default:
            break
        }
        NSUserDefaults.standardUserDefaults().setBool(GameManager.sharedInstance.userDidEnableSound , forKey: "userDidEnableSound")
        NSUserDefaults.standardUserDefaults().setBool(GameManager.sharedInstance.userDidEnableSoundFX , forKey: "userDidEnableSoundFX")
    }
    
    func showLeaderBoards(sender : UIButton){
        NSNotificationCenter.defaultCenter().postNotificationName("callGameCenterLeaderBoard", object: nil);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
}