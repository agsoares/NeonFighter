//
//  Rope.swift
//  MC2
//
//  Created by Adriano Soares on 07/06/15.
//  based on: https://github.com/mraty/spritekit-ropes
//

import SpriteKit

class Rope: SKNode {
    fileprivate var ropeImage = ""
    fileprivate var ropeParts = Array<SKSpriteNode>()
    fileprivate var attachedObject: SKSpriteNode!
    fileprivate var startNode: SKNode!
    fileprivate var positionOnStartNode: CGPoint!
    
    var physicsWorld: SKPhysicsWorld?

    var gameManager = GameManager.sharedInstance
    
    func setAttachmentPoint(_ point: CGPoint, toNode node: SKNode) {
        startNode = node
        positionOnStartNode = point
    }
    
    func attachObject(_ object: SKSpriteNode) {
        attachedObject = object
    }
    
    func setRopeLenght(_ lenght: Int, withImageNamed imageNamed: String) {
        ropeImage = imageNamed
        ropeParts.removeAll(keepingCapacity: false)
        
        let firstPart = SKSpriteNode(imageNamed: ropeImage)
        firstPart.position = positionOnStartNode;
        firstPart.physicsBody = SKPhysicsBody(circleOfRadius: firstPart.size.width)
        firstPart.physicsBody?.allowsRotation = true
        firstPart.physicsBody?.mass = CGFloat(0.005);
        firstPart.physicsBody?.affectedByGravity = false;
        firstPart.physicsBody?.categoryBitMask = PhysicsCategory.Chain
        firstPart.physicsBody?.contactTestBitMask = PhysicsCategory.None;
        firstPart.physicsBody?.collisionBitMask = PhysicsCategory.All & ~PhysicsCategory.Wall

        
        ropeParts.append(firstPart)
        startNode.parent?.addChild(firstPart)
        
        for i in 1..<lenght {
            let ropePart = SKSpriteNode(imageNamed: ropeImage)
            let ropeHeight = firstPart.position.y-CGFloat(i-1)*ropePart.size.height
            
            ropePart.position = CGPoint(x: firstPart.position.x, y: ropeHeight);
            ropePart.physicsBody = SKPhysicsBody(circleOfRadius: ropePart.size.height*0.75)
            ropePart.physicsBody?.allowsRotation = true;
            ropePart.physicsBody?.mass = CGFloat(0.005);
            ropePart.physicsBody?.affectedByGravity = false;
            ropePart.physicsBody?.categoryBitMask = PhysicsCategory.Chain
            ropePart.physicsBody?.contactTestBitMask = PhysicsCategory.None;
            ropePart.physicsBody?.collisionBitMask = PhysicsCategory.All & ~PhysicsCategory.Wall


            //ropePart.physicsBody?.collisionBitMask = 0;
            ropeParts.append(ropePart)
            startNode.parent?.addChild(ropePart)
        }
        
        if let attachedObject = self.attachedObject {
            let ropeEnding:SKNode = ropeParts.last!
            attachedObject.position = CGPoint(x: ropeEnding.position.x, y: ropeEnding.frame.maxY)
            attachedObject.physicsBody = SKPhysicsBody(circleOfRadius: attachedObject.size.height/2)

            ropeParts.append(attachedObject)
            startNode.parent?.addChild(attachedObject)
        }
        
        ropePhysics()
    }
    
    func ropeLength () -> Int {
        return ropeParts.count
    }
    
    func ropePhysics () {

        let nodeA = startNode
        let nodeB = ropeParts.first!
        
        let joint = SKPhysicsJointPin.joint(withBodyA: (nodeA?.physicsBody!)!, bodyB:nodeB.physicsBody!,
            anchor:positionOnStartNode)
        joint.upperAngleLimit = CGFloat(M_PI/4);
        joint.shouldEnableLimits = true;
        startNode.scene?.physicsWorld.add(joint)
        
        
        for i in 1..<ropeLength() {
            let nodeA = ropeParts[i-1]
            let nodeB = ropeParts[i]
        
            let joint = SKPhysicsJointPin.joint(withBodyA: nodeA.physicsBody!, bodyB:nodeB.physicsBody!,
                anchor:CGPoint(x: nodeA.frame.midX, y: nodeA.frame.minY))
            joint.upperAngleLimit = CGFloat(M_PI/4);
            joint.shouldEnableLimits = true;
            startNode.scene?.physicsWorld.add(joint)
        }
        
        let anchorB = ropeParts.last!.position
        let limit = SKPhysicsJointLimit.joint(withBodyA: startNode.physicsBody!, bodyB: (ropeParts.last!.physicsBody)!, anchorA: positionOnStartNode, anchorB: anchorB);
        limit.maxLength = startNode.frame.maxY - ropeParts.last!.frame.minY - 10
        startNode.scene?.physicsWorld.add(limit)
    }
}
