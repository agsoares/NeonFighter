//
//  InterfaceController.swift
//  MC2 WatchKit Extension
//
//  Created by Hariel Giacomuzzi on 7/1/15.
//
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var score = 0;
    
    @IBOutlet weak var lblBestScore: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        super.willActivate()
        var dict = NSDictionary(dictionary: ["action" : "getBestScores"])
        WKInterfaceController.openParentApplication(["action" : "getBestScores"], reply: { (obj: [NSObject : AnyObject]!, error: NSError!) -> Void in
            if let dic = obj as NSDictionary!{
                self.score = (dic.valueForKey("bestScore")) as! Int;
                self.lblBestScore.setText("Your Best Score is \(self.score)")
            }
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
