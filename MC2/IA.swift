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
    var gm = GameManager.sharedInstance;
    var player : SKNode;
    
    init(){
        self.player = gm.player!
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
        return CGVector(dx: player.position.x - enemy.position.x , dy: player.position.y - enemy.position.y );
    }
    
    func getNormalizedVectorToPlayer(enemy : SKNode) -> CGVector{
        return getNormalizedVector(CGVector(dx: player.position.x - enemy.position.x , dy: player.position.y - enemy.position.y ));
    }
    
    func getVectorNormal(vector : CGVector) -> CGFloat{
        var a = pow(vector.dx, 2.0);
        var b = pow(vector.dy, 2.0);
        return sqrt(a + b);
    }
    
    func getNormalizedVector(vector : CGVector) -> CGVector{
        var normal = getVectorNormal(vector);
        return CGVector(dx: vector.dx/normal, dy: vector.dy/normal);
    }
    
    func getAngleToPlayer(enemy : SKNode) -> CGFloat{
        var radians = atan2(enemy.position.x, enemy.position.y);
        var degrees = radians * CGFloat(180.0 / M_PI)
        //println(degrees);
        return degrees%360;
    }
    
}