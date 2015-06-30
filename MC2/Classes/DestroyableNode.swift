//
//  DestroyableNode.swift
//  MC2
//
//  Created by Adriano Soares on 29/06/15.
//
//

import SpriteKit


class DestroyableNode: SKSpriteNode {
    var maxLife: CGFloat = 40000.0;
    var life: CGFloat = 40000.0;
    var initialColor: UIColor!
    var finalColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size);
        self.colorBlendFactor = 1;
        initialColor = color;
        life = maxLife;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDamage(impact: CGFloat) {
        life -= impact
        //self.color = colorLerp(initialColor, to: finalColor, t: life/maxLife)
    }
    
    func colorLerp(from: UIColor, to: UIColor, t: CGFloat) -> UIColor {
        var time = t
        if(t < 0.0) { time = 0.0; }
        if(t > 1.0) { time = 1.0; }
        
        var fromComponent = CGColorGetComponents(from.CGColor)
        var toComponent = CGColorGetComponents(to.CGColor)
        var fromAlpha = CGColorGetAlpha(from.CGColor)
        var toAlpha = CGColorGetAlpha(to.CGColor)

        /*
        var r = fromComponent[0] + (toComponent[0] - fromComponent[0]) * time;
        var g = fromComponent[1] + (toComponent[1] - fromComponent[1]) * time;
        var b = fromComponent[2] + (toComponent[2] - fromComponent[3]) * time;
        var a = fromAlpha + (toAlpha - fromAlpha) * time;
        */
        
        var r = (1.0 - time) * fromComponent[0] + (toComponent[0] * time);
        var g = (1.0 - time) * fromComponent[1] + (toComponent[1] * time);
        var b = (1.0 - time) * fromComponent[2] + (toComponent[2] * time);
        var a = (1.0 - time) * fromAlpha + (toAlpha * time);
        return UIColor(red: r, green: g, blue: b, alpha: a);
    }

    
    /*


    - (UIColor *)colorLerpFrom:(UIColor *)start
    to:(UIColor *)end
    withDuration:(float)t
    {
    if(t < 0.0f) t = 0.0f;
    if(t > 1.0f) t = 1.0f;

    const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(end.CGColor);

    float startAlpha = CGColorGetAlpha(start.CGColor);
    float endAlpha = CGColorGetAlpha(end.CGColor);

    float r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
    float g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
    float b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
    float a = startAlpha + (endAlpha - startAlpha) * t;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    */
}
