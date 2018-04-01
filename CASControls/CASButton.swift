//
//  CASButton.swift
//  UIButtonDemo
//
//  Created by Caspar on 2/7/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import UIKit

class CASButton: UIButton {
    enum ImagePosition {
        case left
        case right
        case top
        case bottom
    }
    var imagePosition: ImagePosition = .left
    private let imagePercent: CGFloat = 0.3
    private let leadingAndTrailingGap: CGFloat = 8
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if self.titleLabel?.isHidden == true {
            return contentRect
        }
        if self.imageView?.isHidden == true {
            return CGRect.zero
        }
        let titleSize = self.titleLabel?.sizeThatFits(contentRect.size) ?? CGSize.zero
        if titleSize.height == 0 || titleSize.width == 0 {
            return contentRect
        }

        // title and image, both exist
        switch imagePosition {
        case .left:
            let imageWidth = contentRect.width * imagePercent
            let imageHeight = contentRect.height * imagePercent
            var startX: CGFloat = 0
            switch contentHorizontalAlignment {
            case .center:
                startX = (contentRect.width - imageWidth - titleSize.width) / 2.0
            case .fill:
                startX = 0
            case .left:
                startX = 0
            case .right:
                startX = contentRect.width - imageWidth - titleSize.width
            case .leading:
                startX = (contentRect.width - imageWidth - titleSize.width) > leadingAndTrailingGap ? leadingAndTrailingGap : (contentRect.width - imageWidth - titleSize.width)
            case .trailing:
                startX = (contentRect.width - imageWidth - titleSize.width) > leadingAndTrailingGap ? leadingAndTrailingGap : (contentRect.width - imageWidth - titleSize.width)
            }

            
        case .right:
            let imageWidth = contentRect.width * imagePercent
            let imageHeight = contentRect.height * imagePercent
            var startX: CGFloat = 0
            switch contentHorizontalAlignment {
            case .center:
                startX = (contentRect.width - imageWidth - titleSize.width) / 2.0
            case .fill:
                startX = 0
            case .left:
                startX = 0
            case .right:
                startX = contentRect.width - imageWidth - titleSize.width
            case .leading:
                startX = (contentRect.width - imageWidth - titleSize.width) > leadingAndTrailingGap ? leadingAndTrailingGap : (contentRect.width - imageWidth - titleSize.width)
            case .trailing:
                startX = (contentRect.width - imageWidth - titleSize.width) > leadingAndTrailingGap ? leadingAndTrailingGap : (contentRect.width - imageWidth - titleSize.width)
            }
//            return CGRect(x: imagePosition == .left ? startX : , y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
            return CGRect.zero
        case .top:
            return CGRect.zero
        case .bottom:
            return CGRect.zero
        }
        return CGRect.zero
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        switch imagePosition {
        case .left:
            return CGRect.zero
        case .right:
            return CGRect.zero
        case .top:
            return CGRect.zero
        case .bottom:
            return CGRect.zero
        }
    }
    
    /// 方式1
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//         // use system default
//        if imagePosition == .left
//            || self.imageView?.isHidden == true
//            || self.titleLabel?.isHidden == true {
//            return
//        }
//
//        // only show image if self's frame < subviews.frame
//        let imageFrame = self.imageView?.frame ?? CGRect.zero
//        let titleFrame = self.titleLabel?.frame ?? CGRect.zero
//        var expectedLabelSize = self.titleLabel?.sizeThatFits(self.frame.size) ?? CGSize.zero
//        expectedLabelSize = CGSize(width: min(titleFrame.width, expectedLabelSize.width), height: min(titleFrame.height, expectedLabelSize.height))
//        let isHiddenTitleLabel = expectedLabelSize.width == 0 || expectedLabelSize.height == 0
//
//        switch imagePosition {
//        case .left:
//            break
//        case .right:
//            var leadGap = min(imageFrame.minX, titleFrame.minX)
//            if leadGap < 0 {
//                leadGap = 0
//            }
//            let imageOrigin = CGPoint(x: leadGap + (isHiddenTitleLabel ? 0 : titleFrame.width), y:imageFrame.minY)
//            let titleOrigin = CGPoint(x: leadGap, y:titleFrame.minY)
//            self.imageView?.frame = CGRect(origin: imageOrigin, size: imageFrame.size)
//            self.titleLabel?.frame = CGRect(origin: titleOrigin, size: titleFrame.size)
//        case .top: fallthrough
//        case .bottom:
//            let imageHeightRate: CGFloat = isHiddenTitleLabel ? 1 : 0.3
//            let imageHeight = min(imageHeightRate * self.frame.height, imageFrame.height)
//            let imageWidth = imageHeight / imageFrame.height * imageFrame.width
//            var topGap = min(imageFrame.minY, titleFrame.minY)
//            if topGap < 0 {
//                topGap = 0
//            }
//            let imageOrigin: CGPoint
//            let titleOrigin: CGPoint
//            if (imagePosition == .top) {
//                imageOrigin = CGPoint(x: (self.frame.width - imageWidth) / 2.0, y:topGap)
//                titleOrigin = CGPoint(x: (self.frame.width - expectedLabelSize.width) / 2.0, y:topGap + imageHeight)
//            }else {
//                imageOrigin = CGPoint(x: (self.frame.width - imageWidth) / 2.0, y:self.frame.height - topGap - imageHeight)
//                titleOrigin = CGPoint(x: (self.frame.width - expectedLabelSize.width) / 2.0, y:topGap)
//            }
//            self.imageView?.frame = CGRect(origin: imageOrigin, size: CGSize(width: imageWidth, height:imageHeight))
//            self.titleLabel?.frame = CGRect(origin: titleOrigin, size: expectedLabelSize)
//        }
//    }

}

extension UIButton{
    func subTitle(){
        if self.imageView?.isHidden == true
            || self.titleLabel?.isHidden == true {
            return
        }
        let imageFrame: CGRect = self.imageView?.frame ?? CGRect.zero
        let titleFrame: CGRect = self.titleLabel?.frame ?? CGRect.zero
        if imageFrame.size == .zero || titleFrame.size == .zero {
            return
        }
        let leadGap = imageFrame.minX
        let imageHeightRate: CGFloat = 0.3
        let imageHeight = min(self.frame.height * imageHeightRate, imageFrame.height)
        let imageWidth = imageHeight / imageFrame.height * imageFrame.width
        
        let newImageRect = CGRect(x: self.frame.midX - imageWidth / 2.0, y: (self.frame.height * imageHeightRate - imageHeight) / 2.0, width: imageWidth, height: imageHeight)
        imageEdgeInsets = UIEdgeInsets(top: newImageRect.minY - imageFrame.minY, left: newImageRect.minX - imageFrame.minX, bottom: imageFrame.maxY - newImageRect.maxY, right: imageFrame.maxX - newImageRect.maxX)
        
        let titleHeight = min(self.frame.height * (1 - imageHeightRate), titleFrame.height)
        let titleWidth = titleHeight / titleFrame.height * titleFrame.width
        let newTitleRect = CGRect(x: self.frame.midX - titleWidth / 2.0, y: self.frame.height * imageHeightRate + (self.frame.height * (1 - imageHeightRate) - titleHeight) / 2.0, width: titleWidth, height: titleHeight)
        self.titleEdgeInsets = UIEdgeInsets(top: newTitleRect.minY - titleFrame.minY, left: newTitleRect.minX - titleFrame.minX, bottom: titleFrame.maxY - newTitleRect.maxY, right: titleFrame.maxX - newTitleRect.maxX)
        print("nothing")
    }
}
