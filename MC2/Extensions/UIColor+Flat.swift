//
//  UIColor+Flat.swift
//  MC2
//
//  Created by Adriano Soares on 23/06/15.
//
//

import UIKit

extension UIColor {
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    // MARK: - Colors from https://flatuicolors.com/
    
    class func turquoiseColor() -> UIColor {
        return UIColor.rgb(26, g:188, b:156)
    }
    
    class func greenSeaColor() -> UIColor {
        return UIColor.rgb(22, g:160, b:133)
    }
    
    class func emeraldColor() -> UIColor {
        return UIColor.rgb(46, g:204, b:113)
    }
    
    class func nephritisColor() -> UIColor {
        return UIColor.rgb(39, g:174, b:96)
    }
    
    class func peterRiverColor() -> UIColor {
        return UIColor.rgb(52, g:152, b:219)
    }
    
    class func belizeHoleColor() -> UIColor {
        return UIColor.rgb(41, g:128, b:185)
    }
    
    class func amethystColor() -> UIColor {
        return UIColor.rgb(155, g:89, b:182)
    }
    
    class func wisteriaColor() -> UIColor {
        return UIColor.rgb(142, g:68, b:173)
    }
    
    class func wetAsfaltColor() -> UIColor {
        return UIColor.rgb(52, g:73, b:94);
    }
    
    class func midnightBlueColor() -> UIColor {
        return UIColor.rgb(44, g:62, b:80);
    }
    
    class func sunFlowerColor() -> UIColor {
        return UIColor.rgb(241, g:196, b:15)
    }
    
    /*
    class func orangeColor() -> UIColor {
        return UIColor.rgb(243, g:156, b:18)
    }
    */
    
    class func carrotColor() -> UIColor {
        return UIColor.rgb(241, g:196, b:15)
    }
    
    class func pumpkinColor() -> UIColor {
        return UIColor.rgb(211, g:84, b:0)
    }
    
    class func alizarinColor() -> UIColor {
        return UIColor.rgb(231, g:76, b:60)
    }
    
    class func pomegranateColor() -> UIColor {
        return UIColor.rgb(192, g:57, b:43)
    }
    
    class func cloudsColor() -> UIColor {
        return UIColor.rgb(236, g:240, b:241)
    }
    
    class func silverColor() -> UIColor {
        return UIColor.rgb(189, g:195, b:199)
    }
    
    class func concreteColor() -> UIColor {
        return UIColor.rgb(149, g:165, b:166)
    }
    
    class func asbestosColor() -> UIColor {
        return UIColor.rgb(127, g:140, b:141)
    }
    
    class func randColor() -> UIColor {
        var colors: [UIColor] = [
            UIColor.turquoiseColor(),
            UIColor.emeraldColor(),
            UIColor.peterRiverColor(),
            UIColor.amethystColor(),
            UIColor.sunFlowerColor(),
            UIColor.carrotColor(),
            UIColor.alizarinColor()
        ]
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
    
}
