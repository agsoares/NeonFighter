//
//  Rope.swift
//  MC2
//
//  Created by Adriano Soares on 07/06/15.
//  based on: https://github.com/mraty/spritekit-ropes
//

import SpriteKit

class Rope: SKNode {
    private var ropeImage = ""
    private var ropeParts = Array<SKSpriteNode>()
    private var attachedObject: SKSpriteNode!
    private var startNode: SKNode!
    private var positionOnStartNode: CGPoint!
    
    func setAttachmentPoint(point: CGPoint, toNode node: SKNode) {
        startNode = node
        positionOnStartNode = point
    }
    
    func attachObject(object: SKSpriteNode) {
        attachedObject = object
    }
    
    func setRopeLenght(lenght: Int, withImageNamed imageNamed: String) {
        ropeImage = imageNamed
        ropeParts.removeAll(keepCapacity: false)
        
        var firstPart = SKSpriteNode(imageNamed: ropeImage)
        firstPart.position = positionOnStartNode;
        firstPart.physicsBody = SKPhysicsBody(circleOfRadius: firstPart.size.width)
        firstPart.physicsBody?.allowsRotation = true
        firstPart.physicsBody?.mass = CGFloat(0.005);
        firstPart.physicsBody?.affectedByGravity = false;
        firstPart.physicsBody?.collisionBitMask = 0;
        
        ropeParts.append(firstPart)
        self.scene?.addChild(firstPart)
        
        for i in 1..<lenght {
            var ropePart = SKSpriteNode(imageNamed: ropeImage)
            var ropeHeight = firstPart.position.y-CGFloat(i-1)*ropePart.size.height
            
            ropePart.position = CGPointMake(firstPart.position.x, ropeHeight);
            ropePart.physicsBody = SKPhysicsBody(circleOfRadius: ropePart.size.height*0.75)
            ropePart.physicsBody?.allowsRotation = true;
            ropePart.physicsBody?.mass = CGFloat(0.005);
            ropePart.physicsBody?.affectedByGravity = false;
            //ropePart.physicsBody?.collisionBitMask = 0;
            ropeParts.append(ropePart)
            self.scene?.addChild(ropePart)
        }
        
        if let attachedObject = self.attachedObject {
            var ropeEnding:SKNode = ropeParts.last!
            attachedObject.position = CGPointMake(ropeEnding.position.x, CGRectGetMaxY(ropeEnding.frame))
            attachedObject.physicsBody = SKPhysicsBody(circleOfRadius: attachedObject.size.height/2)

            ropeParts.append(attachedObject)
            self.scene?.addChild(attachedObject)
        }
        
        ropePhysics()
    }
    
    func ropeLength () -> Int {
        return ropeParts.count
    }
    
    func ropePhysics () {

        var nodeA = startNode
        var nodeB = ropeParts.first!
        
        var joint = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody, bodyB:nodeB.physicsBody,
            anchor:positionOnStartNode)
        joint.upperAngleLimit = CGFloat(M_PI/4);
        joint.shouldEnableLimits = true;
        self.scene?.physicsWorld.addJoint(joint)
        
        
        for i in 1..<ropeLength() {
            var nodeA = ropeParts[i-1]
            var nodeB = ropeParts[i]
        
            var joint = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody, bodyB:nodeB.physicsBody,
                anchor:CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)))
            joint.upperAngleLimit = CGFloat(M_PI/4);
            joint.shouldEnableLimits = true;
            self.scene?.physicsWorld.addJoint(joint)
        }
        
        var anchorB = ropeParts.last!.position
        var limit = SKPhysicsJointLimit.jointWithBodyA(startNode.physicsBody, bodyB: ropeParts.last!.physicsBody, anchorA: positionOnStartNode, anchorB: anchorB);
        limit.maxLength = startNode.frame.maxY - ropeParts.last!.frame.minY
        self.scene?.physicsWorld.addJoint(limit)
    }
}
