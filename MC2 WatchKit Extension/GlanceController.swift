//
//  GlanceController.swift
//  MC2 WatchKit Extension
//
//  Created by Hariel Giacomuzzi on 7/1/15.
//
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    @IBOutlet weak var lblBestScore: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        var dict = NSDictionary(dictionary: ["action" : "getBestScores"])
        WKInterfaceController.openParentApplication(["action" : "getBestScores"]) { (reply, error) -> Void in
            println((reply as? NSDictionary)!.valueForKey("bestScore"));
        }
        
        self.lblBestScore.setText("Your Best Score is \n10\nPoints")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
