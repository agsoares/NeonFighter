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
            self.frame.origin = CGPoint(x: 0, y: 0)
            self.setImage(image, for: UIControlState())
        }else{
            self.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.backgroundColor = .red
        }
    }
    
    convenience init(enableImageName: String, selectedImageName: String){
        self.init(imageNamed: enableImageName)
        self.setImage(UIImage(named: selectedImageName), for: UIControlState.selected)
    }
    
    convenience init(image: UIImage){
        self.init()
        self.frame.size = image.size / GameManager.sharedInstance.scaleFactor
        self.frame.origin = CGPoint(x: 0, y: 0)
        self.setImage(image, for: UIControlState())
    }
}
