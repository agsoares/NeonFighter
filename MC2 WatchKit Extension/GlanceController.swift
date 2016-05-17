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

    var score = 0;
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        var dict = NSDictionary(dictionary: ["action" : "getBestScores"])
        WKInterfaceController.openParentApplication(["action" : "getBestScores"], reply: { (obj: [NSObject : AnyObject], error: NSError?) -> Void in
            if let dic = obj as NSDictionary!{
                var aux = 0;
                if (dic.valueForKey("bestScore")) as? Int != nil {
                    aux = (dic.valueForKey("bestScore")) as! Int
                }
                self.score = aux;
                self.lblBestScore.setText("Your Best Score is \(self.score)")
            }
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
