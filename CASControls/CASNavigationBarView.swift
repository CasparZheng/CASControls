//
//  CASNavigationBarView.swift
//  CASControls
//
//  Created by HFY on 2018/6/8.
//  Copyright © 2018年 Caspar. All rights reserved.
//

import UIKit
private let kAnimationTime: TimeInterval = 0.3
private let kPromptFontSize: CGFloat = 14.0
private let kTitleLabelFontSize: CGFloat = 17.0
private let kStackViewItemGap: CGFloat = 4.0

// todo: 1.just display part of items when items too many

class CASNavigationBarView: UIView {
    private var titleLabel: UILabel?
    private var promptLabel: UILabel?
    private var leftStackView: UIStackView?
    private var rightStackView: UIStackView?
    private var triggerFromLeftBarButtonItem: Bool = false
    private var triggerFromLeftBarButtonItems: Bool = false
    private var triggerFromRightBarButtonItem: Bool = false
    private var triggerFromRightBarButtonItems: Bool = false

    var title: String? = nil {
        didSet {
            if title == nil {
                titleLabel?.removeFromSuperview()
                titleLabel = nil
            }else {
                if titleLabel == nil {
                    let label = normalLabel(text: title)
                    label.font = UIFont.boldSystemFont(ofSize: kTitleLabelFontSize)
                    titleLabel = label
                    self.addSubview(label)
                }
                self.titleLabel?.text = title
            }
        }
    }
    
    var titleView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let titleView = titleView {
                self.addSubview(titleView)
            }
        }
    }
    
    var prompt: String? {
        didSet {
            if prompt == nil {
                promptLabel?.removeFromSuperview()
                self.promptLabel = nil
            }else {
                if promptLabel == nil {
                    let label = normalLabel(text: prompt)
                    label.font = UIFont.systemFont(ofSize: kPromptFontSize)
                    promptLabel = label
                    self.addSubview(label)
                }
                self.promptLabel?.text = prompt
            }
        }
    }
    
    /// unsupport
    var backBarButtonItem: UIButton?
    /// unsupport
    var hidesBackButton: Bool = false
    func setHidesBackButton(_ isHide: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: kAnimationTime) {
                self.hidesBackButton = isHide
            }
        }else {
            self.hidesBackButton = isHide
        }
    }
    
    var leftBarButtonItems: Array<UIButton>? {
        didSet {
            if triggerFromLeftBarButtonItems {
                triggerFromLeftBarButtonItems = false
                triggerFromLeftBarButtonItem = false
                return
            }
            if leftBarButtonItems == nil {
                triggerFromLeftBarButtonItems = true
                leftBarButtonItem = nil
                leftStackView?.removeFromSuperview()
                leftStackView = nil
            }else if let items = leftBarButtonItems {
                triggerFromLeftBarButtonItems = true
                leftBarButtonItem = items.first
                leftStackView?.removeFromSuperview()
                leftStackView = normalStackView()
                self.addSubview(leftStackView!)
                for item in items {
                    leftStackView?.addArrangedSubview(item)
                }
            }
        }
    }
    var rightBarButtonItems: Array<UIButton>? {
        didSet {
            if triggerFromRightBarButtonItems {
                triggerFromRightBarButtonItems = false
                triggerFromRightBarButtonItem = false
                return
            }
            if rightBarButtonItems == nil {
                triggerFromRightBarButtonItems = true
                rightBarButtonItem = nil
                rightStackView?.removeFromSuperview()
                rightStackView = nil
            }else if let items = rightBarButtonItems {
                triggerFromRightBarButtonItems = true
                rightBarButtonItem = items.first
                rightStackView?.removeFromSuperview()
                rightStackView = normalStackView()
                self.addSubview(rightStackView!)
                for item in items {
                    rightStackView?.addArrangedSubview(item)
                }
            }
        }
    }
    func setLeftBarButtonItems(_ items: Array<UIButton>?, animated: Bool) {
        if animated {
            UIView.animate(withDuration: kAnimationTime) {
                self.leftBarButtonItems = items
            }
        }else {
            self.leftBarButtonItems = items
        }
    }
    func setRightBarButtonItems(_ items: Array<UIButton>?, animated: Bool) {
        if animated {
            UIView.animate(withDuration: kAnimationTime) {
                self.rightBarButtonItems = items
            }
        }else {
            self.rightBarButtonItems = items
        }
    }
    
    /// unsupport
    var leftItemsSupplementBackButton: Bool = false
    var leftBarButtonItem: UIButton? {
        didSet {
            if triggerFromLeftBarButtonItem {
                triggerFromLeftBarButtonItem = false
                triggerFromLeftBarButtonItems = false
                return
            }
            if leftBarButtonItem == nil && leftBarButtonItems != nil {
                triggerFromLeftBarButtonItem = true
                leftBarButtonItems?.removeFirst()
            }else if let item = leftBarButtonItem {
                triggerFromLeftBarButtonItem = true
                if leftBarButtonItems == nil {
                    leftBarButtonItems = [item]
                }else {
                    let range: Range<Int> = Range.init(NSRange.init(location: 0, length: 1))!
                    leftBarButtonItems?.replaceSubrange(range, with: [item])
                }
            }
        }
    }
    var rightBarButtonItem: UIButton? {
        didSet {
            if triggerFromRightBarButtonItem {
                triggerFromRightBarButtonItem = false
                triggerFromRightBarButtonItems = false
                return
            }
            if rightBarButtonItem == nil && rightBarButtonItems != nil {
                triggerFromRightBarButtonItem = true
                rightBarButtonItems?.removeFirst()
            }else if let item = rightBarButtonItem {
                triggerFromRightBarButtonItem = true
                if rightBarButtonItems == nil {
                    rightBarButtonItems = [item]
                }else {
                    let range: Range<Int> = Range.init(NSRange.init(location: 0, length: 1))!
                    rightBarButtonItems?.replaceSubrange(range, with: [item])
                }
            }
        }
    }
    func setLeftBarButtonItem(_ item: UIButton, animated: Bool) {
        if animated {
            UIView.animate(withDuration: kAnimationTime) {
                self.leftBarButtonItem = item
            }
        }else {
            self.leftBarButtonItem = item
        }
    }
    func setRightBarButtonItem(_ item: UIButton, animated: Bool) {
        if animated {
            UIView.animate(withDuration: kAnimationTime) {
                self.rightBarButtonItem = item
            }
        }else {
            self.rightBarButtonItem = item
        }
    }
    /// unsupport, ios 11.0
    var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .automatic
    /// unsupport, ios 11.0
    var searchController: UISearchController?
    /// unsupport, ios 11.0
    var hidesSearchBarWhenScrolling: Bool = true
    /// image(<) will be displayed in letBarButtonItem location if meet follow two conditions: 1.set this property value to true;2.letBarButtonItem value is nil
    var showDefaultBackButton: Bool = true
    
    convenience override init(frame: CGRect) {
        self.init(height: frame.height)
    }
    
    convenience init() {
        self.init(height: UIApplication.shared.statusBarFrame.height + 44)
    }
    
    /// designated initialize
    init(height: CGFloat) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        func calculateLength(items: [UIButton]?) -> CGFloat {
            var totalLength: CGFloat = 0
            guard let items = items else {
                return 0
            }
            for item in items {
                item.sizeToFit()
                totalLength += item.bounds.width
            }
            return totalLength + CGFloat(items.count - 1) * kStackViewItemGap
        }
        
        func layoutTitleIn(rect: CGRect) {
            func layoutInCenter(view: UIView, supportedRect: CGRect) {
                let size = self.bounds.size
                let originSize = view.bounds.size
                let preferredRect = CGRect.init(x: (size.width - originSize.width) / 2.0, y: supportedRect.midY - originSize.height / 2.0, width: originSize.width, height: originSize.height)
                if supportedRect.contains(preferredRect) {
                    view.frame = preferredRect
                }else if preferredRect.minX >= supportedRect.minX {
                    if (supportedRect.width - originSize.width) > 0 {
                        view.frame = CGRect.init(x: supportedRect.maxX - originSize.width, y: supportedRect.minY, width: originSize.width, height: supportedRect.height)
                    }else {
                        view.frame = supportedRect
                    }
                }else {
                    view.frame = supportedRect
                }
            }
            
            if let titleView = titleView {
                layoutInCenter(view: titleView, supportedRect: rect)
            }else if let titleLabel = titleLabel  {
                titleLabel.sizeToFit()
                layoutInCenter(view: titleLabel, supportedRect: rect)
            }
        }
        
        super.layoutSubviews()
        let size = self.bounds.size
        let hasPromptLabel = promptLabel == nil ? false : true
        let titleHeight: CGFloat = 44.0
        let startLayoutY: CGFloat = size.height - titleHeight
        let startAndEndGap: CGFloat = 8.0
        let stackViewAndTitleGap: CGFloat = (titleLabel != nil || titleView != nil) ? 4.0 : 0 // stack view and title view gap, or stack views gap
        let doubleStartAndEndGap: CGFloat = startAndEndGap * 2
        
        if let leftItems = leftBarButtonItems, let rightItems = rightBarButtonItems {
            let totalLeftLength: CGFloat = calculateLength(items: leftItems)
            let totalRightLength: CGFloat = calculateLength(items: rightItems)
            let totalLength: CGFloat = totalLeftLength + totalRightLength
            if (totalLength + doubleStartAndEndGap) > size.width {
                let useToPercentLength = size.width - doubleStartAndEndGap - stackViewAndTitleGap
                let percentLeftLength = totalLeftLength / totalLength * useToPercentLength
                let percentRightLength = useToPercentLength - percentLeftLength
                leftStackView?.frame = CGRect.init(x: startAndEndGap, y: startLayoutY, width: percentLeftLength, height: titleHeight)
                rightStackView?.frame = CGRect.init(x: size.width - startAndEndGap - percentRightLength, y: startLayoutY, width: percentRightLength, height: titleHeight)
                layoutTitleIn(rect: CGRect.zero)
            }else {
                leftStackView?.frame = CGRect.init(x: startAndEndGap, y: startLayoutY, width: totalLeftLength, height: titleHeight)
                rightStackView?.frame = CGRect.init(x: size.width - startAndEndGap - totalRightLength, y: startLayoutY, width: totalRightLength, height: titleHeight)
                let remainTitleWidth: CGFloat = size.width - doubleStartAndEndGap - totalLength - stackViewAndTitleGap * 2
                if remainTitleWidth > 0 {
                    layoutTitleIn(rect: CGRect.init(x: startAndEndGap + totalLeftLength + stackViewAndTitleGap, y: startLayoutY, width: remainTitleWidth, height: titleHeight))
                }
            }
            
        }else if let leftItems = leftBarButtonItems {
            let totalLength: CGFloat = calculateLength(items: leftItems)
            if (totalLength + doubleStartAndEndGap) > size.width {
                leftStackView?.frame = CGRect.init(x: startAndEndGap, y: startLayoutY, width: size.width - doubleStartAndEndGap, height: titleHeight)
                layoutTitleIn(rect: CGRect.zero)
            }else {
                leftStackView?.frame = CGRect.init(x: startAndEndGap, y: startLayoutY, width: totalLength, height: titleHeight)
                let remainTitleWidth: CGFloat = size.width - doubleStartAndEndGap - totalLength - stackViewAndTitleGap * 2
                if remainTitleWidth > 0 {
                    layoutTitleIn(rect: CGRect.init(x: startAndEndGap + totalLength + stackViewAndTitleGap, y: startLayoutY, width: remainTitleWidth, height: titleHeight))
                }
            }
        }else if let rightItems = rightBarButtonItems {
            let totalLength: CGFloat = calculateLength(items: rightItems)
            if (totalLength + doubleStartAndEndGap) > size.width {
                rightStackView?.frame = CGRect.init(x: startAndEndGap, y: startLayoutY, width: size.width - doubleStartAndEndGap, height: titleHeight)
                layoutTitleIn(rect: CGRect.zero)
            }else {
                rightStackView?.frame = CGRect.init(x: size.width - startAndEndGap - totalLength, y: startLayoutY, width: totalLength, height: titleHeight)
                let remainTitleWidth: CGFloat = size.width - doubleStartAndEndGap - totalLength - stackViewAndTitleGap * 2
                if remainTitleWidth > 0 {
                    layoutTitleIn(rect: CGRect.init(x: remainTitleWidth + stackViewAndTitleGap, y: startLayoutY, width: remainTitleWidth, height: titleHeight))
                }
            }
        }else {
            layoutTitleIn(rect: CGRect.init(x: startAndEndGap, y: startLayoutY, width: size.width - doubleStartAndEndGap, height: titleHeight))
        }
        
        if hasPromptLabel {
            let promptHeight: CGFloat = 34.0
            promptLabel?.frame = CGRect.init(x: startAndEndGap, y: startLayoutY - promptHeight, width: size.width - doubleStartAndEndGap, height: promptHeight)
        }
    }
}

// MARK: private
extension CASNavigationBarView {
    private func normalLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }
    private func normalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = UIStackViewAlignment.center
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fillProportionally
        stackView.spacing = kStackViewItemGap
        return stackView
    }
}
