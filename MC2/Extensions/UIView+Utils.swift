//
//  UIView+Utils.swift
//  MC2
//
//  Created by Adriano Soares on 27/07/15.
//
//

import UIKit

extension UIView {
    func addCallback(_ target: AnyObject, callback: Selector) {
        if (self is UIButton) {
            if let button = self as? UIButton {
                button.addTarget(target,
                       action: callback,
                       for: .touchUpInside);
            
            }
        } else {
            for view in self.subviews {
                view.addCallback(target, callback: callback);
            }
        }
    }
}
