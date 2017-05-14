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
    
    func showLeaderBoards(_ view : UIViewController){
        if (self.gameCenterEnabled){
            let gc = GKGameCenterViewController()
            gc.gameCenterDelegate = GameCenterManager.gcManager
            view.present(gc, animated: true, completion: nil)
        }
    }
    
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer(_ view : UIViewController){
        self.localPlayer = GKLocalPlayer.localPlayer();

        /*
        self.localPlayer.authenticateHandler = { (controler : UIViewController?, error : NSError?) -> Void  in
            if(controler != nil){
                view.present(controler!, animated: true, completion: nil)
            } else {
                
                if (GKLocalPlayer.localPlayer().isAuthenticated) {
                    self.gameCenterEnabled = true;
                    
                    GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier, error) -> Void in
                        if(error != nil){
                            print(error);
                        } else {
                            self.leaderBoardIdentifier = leaderboardIdentifier!;
                        }
                    });
                    
                }
            
            }
        }
        */

    }
    
    func reportScore(_ score : Int){
        if(self.gameCenterEnabled){
            if #available(iOS 8.0, *) {
                let scoreToReport = GKScore(leaderboardIdentifier: "com.bepid.MC2.NeonFighterLeaderBoard", player: self.localPlayer)
                scoreToReport.value = Int64(score)
                GKScore.report([scoreToReport], withCompletionHandler: nil)
            } else {
                // Fallback on earlier versions
            }

        }
    }
    
}
