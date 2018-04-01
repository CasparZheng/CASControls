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
}
