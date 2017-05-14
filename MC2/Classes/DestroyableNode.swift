//
//  DestroyableNode.swift
//  MC2
//
//  Created by Adriano Soares on 29/06/15.
//
//

import SpriteKit


class DestroyableNode: SKSpriteNode {
    var gameManager = GameManager.sharedInstance
    
    
    var maxLife: CGFloat = 40000.0;
    var life: CGFloat = 40000.0;
    var initialColor: UIColor!
    var finalColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size);
        self.colorBlendFactor = 1;
        initialColor = color;
        life = maxLife;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDamage(_ impact: CGFloat) {
        life -= impact
        if (self.life < 0.0) {
            self.removeFromParent();
            if (self.physicsBody?.categoryBitMask == PhysicsCategory.Enemy) {
                gameManager.score += 1;
            }
        }
    }
    
    func sparkle (_ point : CGPoint) {
        let sparkles = SKTexture(imageNamed: "rope_ring") //reusing the bird texture for now
        let emitter = SKEmitterNode()
        emitter.particleTexture = sparkles
        emitter.position = point
        emitter.particleBirthRate = 450
        emitter.numParticlesToEmit = 50
        emitter.emissionAngleRange = 360
        emitter.particleLifetime = 1
        emitter.particleSpeed = 50.0
        emitter.particleSpeedRange = 50;
        emitter.xAcceleration = 0
        emitter.yAcceleration = -40
        emitter.particleColorBlendFactor = 1
        emitter.particleColor = self.color
        
        self.parent?.addChild(emitter)
    }
    
    func colorLerp(_ from: UIColor, to: UIColor, t: CGFloat) -> UIColor {
        var time = t
        if(t < 0.0) { time = 0.0; }
        if(t > 1.0) { time = 1.0; }
        
        let fromComponent = from.cgColor.components
        let toComponent = to.cgColor.components
        let fromAlpha = from.cgColor.alpha
        let toAlpha = to.cgColor.alpha
        
        let r = (1.0 - time) * (fromComponent?[0])! + ((toComponent?[0])! * time);
        let g = (1.0 - time) * (fromComponent?[1])! + ((toComponent?[1])! * time);
        let b = (1.0 - time) * (fromComponent?[2])! + ((toComponent?[2])! * time);
        let a = (1.0 - time) * fromAlpha + (toAlpha * time);
        return UIColor(red: r, green: g, blue: b, alpha: a);
    }
}
