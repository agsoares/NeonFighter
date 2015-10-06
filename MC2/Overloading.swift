//
//  Overloading.swift
//  MC2
//
//  Created by Marcus Vinicius Kuquert on 01/07/15.
//
//
import CoreGraphics


func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSizeMake(left.width * right, left.height * right)
}
func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSizeMake(left.width / right, left.height / right)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}