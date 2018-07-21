//
//  CASAlignView.swift
//  CASControls
//
//  Created by HFY on 2018/7/20.
//  Copyright © 2018年 Caspar. All rights reserved.
//

import UIKit

enum CASAlignStyle: UInt {
    case normal
    case blur
}

private let kVerticalTitleHeight: CGFloat = 36.0

typealias CASAlignAction = ((CASGestureType)->Void)

class CASAlignView: UIView {
    var imagePosition: CASPosition = .top
    //    {
    //        didSet {
    //            switch imagePosition {
    //            case .left:fallthrough
    //            case .right:
    //                imagesAlignDirection = .vertical
    //                titlesAlignDirection = .vertical
    //            case .bottom:fallthrough
    //            case .top:
    //                imagesAlignDirection = .horizontal
    //                titlesAlignDirection = .horizontal
    //            }
    //        }
    //    }
    var style: CASAlignStyle = .normal
    /// only horizontal or vertical can effect
    var imagesAlignDirection: CASDirection = .horizontal {
        didSet {
            if imagesAlignDirection == .horizontal {
                self.imagesStackView.axis = .horizontal
            }else {
                self.imagesStackView.axis = .vertical
            }
            self.setNeedsLayout()
        }
    }
    
    /// only horizontal or vertical can effect
    var titlesAlignDirection: CASDirection = .vertical {
        didSet {
            if titlesAlignDirection == .horizontal {
                self.titlesStackView.axis = .horizontal
            }else {
                self.titlesStackView.axis = .vertical
            }
            self.setNeedsLayout()
        }
    }
    
    /// titlesPercent = 1 - imagesPrecent
    var imagesPercent: CGFloat = 0.5
    
    private var imagesStackView: UIStackView = UIStackView()
    private var titlesStackView: UIStackView = UIStackView()
    private var innerViewId: Int = 1
    private var actions: [String:CASActionModel] = [:]
    private var containerView: UIView = UIView()
    private var isContainsButton: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.addSubview(imagesStackView)
        containerView.addSubview(titlesStackView)
        
        imagesStackView.alignment = UIStackViewAlignment.center
        imagesStackView.distribution = UIStackViewDistribution.fillProportionally
        
        titlesStackView.alignment = UIStackViewAlignment.center
        titlesStackView.distribution = UIStackViewDistribution.fillProportionally
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    deinit {
        print("\(self) deinit)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let edge: UIEdgeInsets = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        let size: CGSize = self.bounds.size
        let itemGap: CGFloat = 8.0
        let buttonHeight: CGFloat = 36.0
        
        containerView.frame = self.bounds
        if self.imagesStackView.arrangedSubviews.count > 0 && self.titlesStackView.arrangedSubviews.count > 0 {
            switch imagePosition {
            case .left:
                let imageWidth: CGFloat = size.width * imagesPercent
                let titleWidth: CGFloat = size.width * (1 - imagesPercent)
                
                let imagesLayoutFrame: CGRect = CGRect.init(x: 0, y: 0, width: imageWidth, height: size.height)
                if self.imagesStackView.axis == .horizontal {
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: edge.bottom, right: 0)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                    
                }else {
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: edge.bottom, right: edge.right / 2.0)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                }
                
                if self.titlesStackView.axis == .horizontal {
                    let innerTitleEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left / 2.0, bottom: edge.bottom, right: edge.right)
                    let titlesLayoutFrame: CGRect = CGRect.init(x: imagesLayoutFrame.maxX, y: 0, width: titleWidth, height: size.height)
                    self.titlesStackView.frame = UIEdgeInsetsInsetRect(titlesLayoutFrame, innerTitleEdge)
                    
                }else {
                    let estimateHeight: CGFloat = (buttonHeight + itemGap) * CGFloat(self.titlesStackView.arrangedSubviews.count) - itemGap
                    if estimateHeight < size.height {
                        let titlesLayoutFrame: CGRect = CGRect.init(x: imagesLayoutFrame.maxX, y: (size.height - estimateHeight) / 2.0, width: titleWidth, height: estimateHeight)
                        self.titlesStackView.frame = titlesLayoutFrame
                    }else {
                        let innerTitleEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left / 2.0, bottom: edge.bottom, right: edge.right)
                        let titlesLayoutFrame: CGRect = CGRect.init(x: imagesLayoutFrame.maxX, y: 0, width: titleWidth, height: size.height)
                        self.titlesStackView.frame = UIEdgeInsetsInsetRect(titlesLayoutFrame, innerTitleEdge)
                    }
                }
                
                
            case .right:
                let imageWidth: CGFloat = size.width * imagesPercent
                let titleWidth: CGFloat = size.width * (1 - imagesPercent)
                
                let titlesLayoutFrame: CGRect = CGRect.init(x: 0, y: 0, width: titleWidth, height: size.height)
                if self.imagesStackView.axis == .horizontal {
                    let imagesLayoutFrame: CGRect = CGRect.init(x: titlesLayoutFrame.maxX, y: 0, width: imageWidth, height: size.height)
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: 0, bottom: edge.bottom, right: edge.right)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                    
                }else {
                    let imagesLayoutFrame: CGRect = CGRect.init(x: titlesLayoutFrame.maxX, y: 0, width: imageWidth, height: size.height)
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left / 2.0, bottom: edge.bottom, right: edge.right)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                }
                
                if self.titlesStackView.axis == .horizontal {
                    let innerTitleEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: edge.bottom, right: edge.right / 2.0)
                    self.titlesStackView.frame = UIEdgeInsetsInsetRect(titlesLayoutFrame, innerTitleEdge)
                    
                }else {
                    let halfWidth = size.width / 2.0
                    let estimateHeight: CGFloat = (buttonHeight + itemGap) * CGFloat(self.titlesStackView.arrangedSubviews.count) - itemGap
                    if estimateHeight < size.height {
                        let titlesLayoutFrame: CGRect = CGRect.init(x: 0, y: (size.height - estimateHeight) / 2.0, width: titleWidth, height: estimateHeight)
                        self.titlesStackView.frame = titlesLayoutFrame
                    }else {
                        let innerTitleEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: edge.bottom, right: edge.right / 2.0)
                        let titlesLayoutFrame: CGRect = CGRect.init(x: 0, y: 0, width: halfWidth, height: size.height)
                        self.titlesStackView.frame = UIEdgeInsetsInsetRect(titlesLayoutFrame, innerTitleEdge)
                    }
                }
                
            case .bottom:
                let imageHeight: CGFloat = size.height * imagesPercent
                let titleHeight: CGFloat = size.height * (1 - imagesPercent)
                let titlesLayoutFrame: CGRect = CGRect.init(x: 0, y: 0, width: size.width, height: titleHeight)
                if self.imagesStackView.axis == .horizontal {
                    let imagesLayoutFrame: CGRect = CGRect.init(x: 0, y: titlesLayoutFrame.maxY, width: size.width, height: imageHeight)
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top / 2.0, left: edge.left, bottom: edge.bottom, right: edge.right)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                }else {
                    let imagesLayoutFrame: CGRect = CGRect.init(x: 0, y: titlesLayoutFrame.maxY, width: size.width, height: imageHeight)
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: edge.left, bottom: edge.bottom, right: edge.right)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                }
                
                let innerTitleEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: edge.bottom / 2.0, right: edge.right)
                self.titlesStackView.frame = UIEdgeInsetsInsetRect(titlesLayoutFrame, innerTitleEdge)
                
            case .top:
                let imageHeight: CGFloat = size.height * imagesPercent
                let titleHeight: CGFloat = size.height * (1 - imagesPercent)
                let imagesLayoutFrame: CGRect = CGRect.init(x: 0, y: 0, width: size.width, height: imageHeight)
                if self.imagesStackView.axis == .horizontal {
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: 0, right: edge.right)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                }else {
                    let innerImageEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top, left: edge.left, bottom: edge.bottom / 2.0, right: edge.right)
                    self.imagesStackView.frame = UIEdgeInsetsInsetRect(imagesLayoutFrame, innerImageEdge)
                }
                
                let titlesLayoutFrame: CGRect = CGRect.init(x: 0, y: imagesLayoutFrame.maxY, width: size.width, height: titleHeight)
                let innerTitleEdge: UIEdgeInsets = UIEdgeInsets.init(top: edge.top / 2.0, left: edge.left, bottom: edge.bottom, right: edge.right)
                self.titlesStackView.frame = UIEdgeInsetsInsetRect(titlesLayoutFrame, innerTitleEdge)
                
            }
        }else if self.imagesStackView.arrangedSubviews.count > 0 {
            self.imagesStackView.frame = UIEdgeInsetsInsetRect(self.bounds, edge)
        }else if self.titlesStackView.arrangedSubviews.count > 0 {
            self.titlesStackView.frame = UIEdgeInsetsInsetRect(self.bounds, edge)
        }else {
            // no stackView need to align
        }
        
    }
    
    /// causion: action will capture outter self lead to retain cycle
    func addImage(image: UIImage?, action:CASAlignAction?, actionType: CASGestureType) {
        let imageView = UIImageView()
        self.alignAlertId(view: imageView)
        imageView.image = image
        if action != nil {
            imageView.isUserInteractionEnabled = true
            combine(view: imageView, action: action, actionType: actionType)
        }
        self.imagesStackView.addArrangedSubview(imageView)
    }
    
    /// causion: action will capture outter self lead to retain cycle
    func addTitle(title: String?, action:CASAlignAction?, actionType: CASGestureType) {
        func normalLabel() -> UILabel {
            let label: UILabel = UILabel.init()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 14)
            return label
        }
        func normalButton() -> UIButton {
            let button: UIButton = InnerButton.init(type: UIButtonType.custom)
            let label: UILabel = normalLabel()
            button.titleLabel?.font = label.font
            button.setTitleColor(label.textColor, for: UIControlState.normal)
            return button
        }
        
        if let action = action {
            let button: UIButton = normalButton()
            button.backgroundColor = UIColor.init(red: CGFloat(0xff) / 256.0, green: CGFloat(0xd2) / 256.0, blue: CGFloat(0x00) / 256.0, alpha: 1.0)
            self.alignAlertId(view: button)
            var innerTitle: String = ""
            if let title = title {
                innerTitle = "   \(title)   "
            }
            button.setTitle(innerTitle, for: UIControlState.normal)
            combine(view: button, action: action, actionType: actionType)
            self.titlesStackView.addArrangedSubview(button)
        }else {
            let label: UILabel = normalLabel()
            self.alignAlertId(view: label)
            label.text = title
            self.titlesStackView.addArrangedSubview(label)
        }
    }
}

private class InnerButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.layer.masksToBounds = true
    }
    
}

private extension UIView {
    private struct AssociatedKey {
        static var kAlertId = "kAlertId"
    }
    
    @objc var alertId: Int {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKey.kAlertId) as? Int {
                return value
            }else {
                return 0
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.kAlertId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

//MARK: private method

private extension CASAlignView {
    private func alignAlertId(view: UIView) {
        view.alertId = alertId
        alertId = alertId + 1
    }
    
    private func combine(view: UIView, action:CASAlignAction?, actionType: CASGestureType) {
        var gesture: UIGestureRecognizer? = nil
        switch actionType {
        case .pan:
            gesture = UIPanGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
        case .longPress:
            gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
        case .pinch:
            gesture = UIPinchGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
        case .swip(let direction):
            gesture = UISwipeGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
            if let gesture = gesture as? UISwipeGestureRecognizer {
                switch direction {
                case .left:
                    gesture.direction = .left
                case .right:
                    gesture.direction = .right
                case .up:
                    gesture.direction = .up
                case .down:
                    gesture.direction = .down
                case .horizontal:
                    gesture.direction = [.left, .right]
                case .vertical:
                    gesture.direction = [.up, .down]
                case .all:
                    gesture.direction = [.left, .right, .up, .down]
                }
            }
        case .tap:
            gesture = UITapGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
        case .rotation:
            gesture = UIRotationGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
        case .none:
            break
        }
        
        if let gesture = gesture {
            let actionModel = CASActionModel.init(actionType: actionType, action: action)
            let key = String.init(format: "%d", view.alertId)
            self.actions[key] = actionModel
            view.addGestureRecognizer(gesture)
        }
    }
}

// gesture actions
extension CASAlignView {
    @objc private func gestureAction(gesture: UIGestureRecognizer) {
        if let view = gesture.view {
            let key = String.init(format: "%d", view.alertId)
            guard let actionModel: CASActionModel = self.actions[key], let action = actionModel.action else {
                return
            }
            action(actionModel.actionType)
        }
    }
}


private class CASActionModel {
    let actionType: CASGestureType
    let action: CASAlignAction?
    
    convenience init() {
        self.init(actionType: CASGestureType.none, action: nil)
    }
    
    init(actionType: CASGestureType, action: CASAlignAction?) {
        self.actionType = actionType
        self.action = action
    }
    
}

