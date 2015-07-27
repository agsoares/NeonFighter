//
//  UIView+Utils.swift
//  MC2
//
//  Created by Adriano Soares on 27/07/15.
//
//

extension UIView {
    func addCallback(target: AnyObject, callback: Selector) {
        if (self is UIButton) {
            if let button = self as? UIButton {
                button.addTarget(target,
                       action: callback,
                       forControlEvents: .TouchUpInside);
            
            }
        } else {
            for view in self.subviews {
                view.addCallback(target, callback: callback);
            }
        }
    }
}
