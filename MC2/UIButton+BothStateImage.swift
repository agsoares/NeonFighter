//
//  UIButton+BothStateImage.swift
//  MC2
//
//  Created by Marcus Vinicius Kuquert on 02/07/15.
//
//

import UIKit

extension UIButton{

    convenience init(imageNamed: String){
        self.init()
        if let image = UIImage(named: imageNamed){
            self.frame.size = image.size / GameManager.sharedInstance.scaleFactor
            self.frame.origin = CGPointMake(0, 0)
            self.setImage(image, forState: .Normal)
        }else{
            self.frame = CGRectMake(0, 0, 80, 80)
            self.backgroundColor = .redColor()
        }
    }
    
    convenience init(enableImageName: String, selectedImageName: String){
        self.init(imageNamed: enableImageName)
        self.setImage(UIImage(named: selectedImageName), forState: UIControlState.Selected)
    }
    
    convenience init(image: UIImage){
        self.init()
        self.frame.size = image.size / GameManager.sharedInstance.scaleFactor
        self.frame.origin = CGPointMake(0, 0)
        self.setImage(image, forState: .Normal)
    }
}