//
//  SKScene+Utils.swift
//  MC2
//
//  Created by Adriano Soares on 27/06/15.
//
//

import SpriteKit

extension SKNode {
    func shake(_ duration:Float, force: Float) {
        let amplitudeX:Float = 1*force;
        let amplitudeY:Float = 1*force;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = CGFloat(Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2)
            let moveY = CGFloat(Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2);
            let shakeAction = SKAction.moveBy(x: moveX, y: moveY, duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        self.run(actionSeq);
    }
}
