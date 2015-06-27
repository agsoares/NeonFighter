//
//  SKScene+Utils.swift
//  MC2
//
//  Created by Adriano Soares on 27/06/15.
//
//

import SpriteKit

extension SKNode {
    
    func shake(duration:Float) {
        let amplitudeX:Float = 50;
        let amplitudeY:Float = 30;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for index in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = CGFloat(Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2)
            let moveY = CGFloat(Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2);
            let shakeAction = SKAction.moveByX(moveX, y: moveY, duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.EaseOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversedAction());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        self.runAction(actionSeq);
    }
}
