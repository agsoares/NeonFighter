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

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        let grid = SKSpriteNode(imageNamed: "grid");
        grid.zPosition = -0.1
        grid.size = CGSize(width: grid.size.width*1.2, height: grid.size.height*1.2)
        grid.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(grid);
        
        gameManager.userDidEnableSoundFX = UserDefaults.standard.bool(forKey: "userDidEnableSoundFX")
        gameManager.userDidEnableSound = UserDefaults.standard.bool(forKey: "userDidEnableSound")

        let menu = Bundle.main.loadNibNamed("MainMenu",
            owner: self,
            options:nil)?.first as! UIView

        
        menu.addCallback(self, callback: Selector("buttonPressed:"));
        AddState(menu)

        if let view = self.view {
            menu.frame = view.frame;
            self.menu = menu;
            view.addSubview(self.menu);
        }

    }

    func AddState (_ view: UIView) {
        for v in view.subviews {
            if (v is UIButton) {
                if let button = v as? UIButton {
                    if(button.tag == 2) {
                        button.isSelected = !GameManager.sharedInstance.userDidEnableSound
                    }
                    if(button.tag == 3) {
                        button.isSelected = !GameManager.sharedInstance.userDidEnableSoundFX
                    }
                }
            } else {
                if let view: UIView = v{
                    AddState(view);
                }
            }
            
        }
    }

    func buttonPressed(_ sender: UIButton){
        if let view = self.view {
            switch sender.tag{
            case 1:
                let scene = GameScene(size: view.frame.size)
                menu.removeFromSuperview();
                view.presentScene(scene)
                break
            case 2:
                sender.isSelected = !sender.isSelected
                GameManager.sharedInstance.userDidEnableSound = !sender.isSelected
                break
            case 3:
                sender.isSelected = !sender.isSelected
                GameManager.sharedInstance.userDidEnableSoundFX = !sender.isSelected
            case 4:
                showLeaderBoards()
            default:
                break
            }
            UserDefaults.standard.set(GameManager.sharedInstance.userDidEnableSound , forKey: "userDidEnableSound")
            UserDefaults.standard.set(GameManager.sharedInstance.userDidEnableSoundFX , forKey: "userDidEnableSoundFX")
        }

    }

    func showLeaderBoards(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "callGameCenterLeaderBoard"), object: nil);
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
