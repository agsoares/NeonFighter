//
//  AnalogStick.swift
//  Joystick
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//
//
import SpriteKit

@objc protocol AnalogStickProtocol {
    func moveAnalogStick(_ analogStick: AnalogStick, velocity: CGPoint, angularVelocity: Float)
}

class AnalogStick: SKNode {
    
    var velocityLoop: CADisplayLink?
    let thumbNode: SKSpriteNode, bgNode: SKSpriteNode
    
    func setThumbImage(_ image: UIImage?, sizeToFit: Bool) {
        let tImage: UIImage = image != nil ? image! : UIImage(named: "aSThumbImg")!
        self.thumbNode.texture = SKTexture(image: tImage)
        if sizeToFit {
            self.thumbNodeDiametr = min(tImage.size.width, tImage.size.height)
        }
    }
    func setBgImage(_ image: UIImage?, sizeToFit: Bool) {
        let tImage: UIImage = image != nil ? image! : UIImage(named: "aSBgImg")!
        self.bgNode.texture = SKTexture(image: tImage)
        if sizeToFit {
            self.bgNodeDiametr = min(tImage.size.width, tImage.size.height)
        }
    }
    var bgNodeDiametr: CGFloat {
        get { return self.bgNode.size.width }
        set { self.bgNode.size = CGSize(width: newValue, height: newValue) }
    }
    var thumbNodeDiametr: CGFloat {
        get { return self.bgNode.size.width }
        set { self.thumbNode.size = CGSize(width: newValue, height: newValue) }
    }
    var delegate: AnalogStickProtocol? {
        didSet {
            velocityLoop?.invalidate()
            velocityLoop = nil
            if delegate != nil {
                velocityLoop = CADisplayLink(target: self, selector: #selector(AnalogStick.update))
                velocityLoop?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            }
        }
    }
    func update() {
        if isTracking {
           delegate?.moveAnalogStick(self, velocity: self.velocity, angularVelocity: self.angularVelocity)
        }
    }
    let kThumbSpringBackDuration: TimeInterval = 0.15 // action duration
    var isTracking = false
    var velocity = CGPoint.zero, anchorPointInPoints = CGPoint.zero
    var angularVelocity = Float()
    convenience init(thumbImage: UIImage?) {
        self.init(thumbImage: thumbImage, bgImage: nil)
    }
    convenience init(bgImage: UIImage?) {
        self.init(thumbImage: nil, bgImage: bgImage)
    }
    convenience override init() {
        self.init(thumbImage: nil, bgImage: nil)
    }
    init(thumbImage: UIImage?, bgImage: UIImage?) {
        self.thumbNode = SKSpriteNode()
        self.bgNode = SKSpriteNode()
        super.init()
        setThumbImage(thumbImage, sizeToFit: true)
        setBgImage(bgImage, sizeToFit: true)
        self.isUserInteractionEnabled = true;
        self.isTracking = false
        self.velocity = CGPoint.zero
        self.addChild(bgNode) // first bg
        self.addChild(thumbNode) // after thumb
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func reset() {
        self.isTracking = false
        self.velocity = CGPoint.zero
        let easeOut: SKAction = SKAction.move(to: self.anchorPointInPoints, duration: kThumbSpringBackDuration)
        easeOut.timingMode = SKActionTimingMode.easeOut
        self.thumbNode.run(easeOut)
    }
    // touch begin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch: AnyObject in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNode = atPoint(location)
            if self.thumbNode == touchedNode && isTracking == false {
                isTracking = true
            }
        }
    }
    // touch move
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event);
        for touch: AnyObject in touches {
            let location = touch.location(in: self);
            let xDistance: Float = Float(location.x - self.thumbNode.position.x)
            let yDistance: Float = Float(location.y - self.thumbNode.position.y)
            if self.isTracking == true || sqrtf(powf(xDistance, 2) + powf(yDistance, 2)) <= Float(self.bgNodeDiametr * 2) {
                let xAnchorDistance: CGFloat = (location.x - self.anchorPointInPoints.x)
                let yAnchorDistance: CGFloat = (location.y - self.anchorPointInPoints.y)
                if sqrt(pow(xAnchorDistance, 2) + pow(yAnchorDistance, 2)) <= self.thumbNode.size.width {
                    let moveDifference: CGPoint = CGPoint(x: xAnchorDistance , y: yAnchorDistance)
                    self.thumbNode.position = CGPoint(x: self.anchorPointInPoints.x + moveDifference.x, y: self.anchorPointInPoints.y + moveDifference.y)
                } else {
                    let magV = sqrt(xAnchorDistance * xAnchorDistance + yAnchorDistance * yAnchorDistance)
                    let aX = self.anchorPointInPoints.x + xAnchorDistance / magV * self.thumbNode.size.width
                    let aY = self.anchorPointInPoints.y + yAnchorDistance / magV * self.thumbNode.size.width
                    self.thumbNode.position = CGPoint(x: aX, y: aY)
                }
                let tNAnchPoinXDiff: CGFloat = self.thumbNode.position.x - self.anchorPointInPoints.x;
                let tNAnchPoinYDiff: CGFloat = self.thumbNode.position.y - self.anchorPointInPoints.y
                self.velocity = CGPoint(x: tNAnchPoinXDiff, y: tNAnchPoinYDiff)
                self.angularVelocity = -atan2f(Float(tNAnchPoinXDiff), Float(tNAnchPoinYDiff))
            }
        }
    }
    // touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
    }
    // touch cancel
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
    }
}
