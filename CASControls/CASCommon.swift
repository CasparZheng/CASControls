//
//  CASCommon.swift
//  CASControls
//
//  Created by Caspar on 4/1/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import UIKit

class CASCommon: NSObject {
    static let shared = CASCommon()
    
    func currentDeviceAvailableRect() -> CGRect {
        var safeInsets: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            safeInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        let rect = UIEdgeInsetsInsetRect(UIScreen.main.bounds, safeInsets)
        return rect
    }
    
    func currentViewController(from view: UIView) -> UIViewController? {
        var innerView: UIView? = view
        while innerView != nil {
            if let responder = innerView?.next, let vc = responder as? UIViewController {
                return vc
            }
            innerView = innerView?.superview
        }
        return nil
    }

}
