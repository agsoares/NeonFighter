//
//  GameCenterManager.swift
//  MC2
//
//  Created by Hariel Giacomuzzi on 6/29/15.
//
//

import Foundation
import GameKit

class GameCenterManager : NSObject, GKGameCenterControllerDelegate{

    static let gcManager = GameCenterManager()
    var gameCenterEnabled = false
    var leaderBoardIdentifier = "com.bepid.MC2.NeonFighterLeaderBoard"
    var localPlayer = GKLocalPlayer()
    
    func showLeaderBoards(view : UIViewController){
        if (self.gameCenterEnabled){
            var gc = GKGameCenterViewController()
            gc.gameCenterDelegate = GameCenterManager.gcManager
            view.presentViewController(gc, animated: true, completion: nil)
        }
    }
    
    @objc func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticateLocalPlayer(view : UIViewController){
        self.localPlayer = GKLocalPlayer.localPlayer();
        
        self.localPlayer.authenticateHandler = { (controler : UIViewController!, error : NSError!) -> Void  in
            if(controler != nil){
                view.presentViewController(controler, animated: true, completion: nil)
            }else{
                if (GKLocalPlayer.localPlayer().authenticated){
                    self.gameCenterEnabled = true;
                    
                GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier, error) -> Void in
                        if(error != nil){
                            println(error);
                        }else{
                            self.leaderBoardIdentifier = leaderboardIdentifier;
                        }
                });
                    
                }
            
            }
        }
    }
    
    func reportScore(score : Int){
        if(self.gameCenterEnabled){
            var scoreToReport = GKScore(leaderboardIdentifier: "com.bepid.MC2.NeonFighterLeaderBoard", player: self.localPlayer)
            scoreToReport.value = Int64(score)
            GKScore.reportScores([scoreToReport], withCompletionHandler: nil)
        }
    }
    
}
