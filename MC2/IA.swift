//
//  IA.swift
//  MC2
//
//  Created by Hariel Giacomuzzi on 6/25/15.
//
//

import Foundation
import CoreGraphics
import SpriteKit

class IA {
    
    var player = SKNode();
    
    init(player : SKNode){
        self.player = player;
    }
    
    func getPathToPlayer(enemy : SKNode) -> CGMutablePathRef{
        var cgpath = CGPathCreateMutable();
        
        var xStart = CGPointMake(enemy.position.x, enemy.position.y);
        var xEnd = CGPointMake(player.position.x, player.position.y);
        
        //ControlPoints
        var cp1 = CGPointMake(xEnd.x/4, xEnd.y/4);
        var cp2 = CGPointMake(3*xEnd.x/4, 3*xEnd.y/4);
        
        CGPathMoveToPoint(cgpath, nil, xStart.x, xStart.y);
        CGPathAddCurveToPoint(cgpath, nil, cp1.x, cp1.y, cp2.x, cp2.y, xEnd.x, xEnd.y)
        
        return cgpath;
    }
    
    func getVectorToPlayer(enemy : SKNode) -> CGVector{
        //println(" <\(enemy.position.x - player.position.x)  , \(enemy.position.x - player.position.y)>")
        return CGVector(dx: player.position.x - enemy.position.x , dy: player.position.y - enemy.position.y );
    }
    
    
}