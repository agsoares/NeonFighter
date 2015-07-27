//
//  MainMenu.swift
//  MC2
//
//  Created by Marcus Vinicius Kuquert on 29/06/15.
//
//
import SpriteKit

class MainMenu: SKScene {
var gameManager = GameManager.sharedInstance

    var menu: UIView!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        var grid = SKSpriteNode(imageNamed: "grid");
        grid.zPosition = -0.1
        grid.size = CGSizeMake(grid.size.width*1.2, grid.size.height*1.2)
        grid.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(grid);


        gameManager.userDidEnableSoundFX = NSUserDefaults.standardUserDefaults().boolForKey("userDidEnableSoundFX")
        gameManager.userDidEnableSound = NSUserDefaults.standardUserDefaults().boolForKey("userDidEnableSound")

        var menu = NSBundle.mainBundle().loadNibNamed("MainMenu",
            owner: self,
            options:nil).first as! UIView

        
        menu.addCallback(self, callback: Selector("buttonPressed:"));
        AddState(menu)

        if let view = self.view {
            menu.frame = view.frame;
            self.menu = menu;
            view.addSubview(self.menu);
        }

    }

    func AddState (view: UIView) {
        for v in view.subviews {
            if (v is UIButton) {
                if let button = v as? UIButton {
                    if(button.tag == 2) {
                        button.selected = !GameManager.sharedInstance.userDidEnableSound
                    }
                    if(button.tag == 3) {
                        button.selected = !GameManager.sharedInstance.userDidEnableSoundFX
                    }
                }
            } else {
                if let view = v as? UIView {
                    AddState(view);
                }
            }
            
        }
    }

    func buttonPressed(sender: UIButton){
        switch sender.tag{
        case 1:
            let scene = GameScene(size: self.view!.frame.size)
            let skView = self.view as SKView?
            menu.removeFromSuperview();


            skView!.presentScene(scene)
            break
        case 2:
            sender.selected = !sender.selected
            GameManager.sharedInstance.userDidEnableSound = !sender.selected
            break
        case 3:
            sender.selected = !sender.selected
            GameManager.sharedInstance.userDidEnableSoundFX = !sender.selected
        case 4:
            showLeaderBoards()
        default:
            break
        }
        NSUserDefaults.standardUserDefaults().setBool(GameManager.sharedInstance.userDidEnableSound , forKey: "userDidEnableSound")
        NSUserDefaults.standardUserDefaults().setBool(GameManager.sharedInstance.userDidEnableSoundFX , forKey: "userDidEnableSoundFX")
    }

    func showLeaderBoards(){
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
