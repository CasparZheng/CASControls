//
//  CASMenuListView.swift
//  ARVControlsDemo
//
//  Created by Caspar on 3/21/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import UIKit
import SnapKit

@objc(CASMenuStyle)
enum CASMenuStyle: Int {
    case dark
}

//@objc(CASMenuItemType)
//enum CASMenuItemType: Int {
//    case normal
//    case highlight
//    case strong
//}

class CASMenuItem: NSObject {
    var title: String
//    var itemType: ItemType
    
    override init() {
        self.title = ""
        super.init()
    }
    
    init(title: String) {
        self.title = title
        super.init()
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}

class CASMenuListAdapter: NSObject {
    typealias Style = CASMenuStyle
    
    var style: Style = .dark
    // whether use the unification font size, if set true, will update fontSize property automatically
    var useUnificationFontSize: Bool = false
    var fontSize: CGFloat = 14.0
    
    // if value is false, all items will layout in one page (UIScreen.main.bounds.width)
    var allInOnePage: Bool = true
    // only effect when allInOnePage is false, if this value is 0, means automatically scroll
    var itemCountPerPage: Int = 0

    var itemSelectedIndicatorSize: CGSize = CGSize.init(width: 40.0, height: 2.0)
    var itemHeight: CGFloat = 48.0
    var itemWidth: CGFloat = 120.0 // only effect when (allInOnePage==false && itemCountPerPage==0)
    
    private let kSelectedFontColorOfStyleDark = UIColor.white
    private let kUnSelectedFontColorOfStyleDark = UIColor.init(white: 1.0, alpha: 0.55)
    private let kBackgroundColorOfStyleDark = UIColor.black
    private let kIndicatorViewColorOfStyleDark = UIColor.init(red: 0xFFp0 / 0xFFp0, green: 0xD2p0 / 0xFFp0, blue: 0x00p0 / 0xFFp0, alpha: 1.0) // 0xFFD200
    private var verticalMaxFontSize: CGFloat = 0 // inner stored for update fontSize
    private var horizontalMaxFontSize: CGFloat = 0 // inner stored for update fontSize
    
    let kItemLabelTrailingAndLeadingGap: CGFloat = 8
    let kCellReuseID = "cellID"

    init(style: Style) {
        self.style = style
        super.init()
    }
    
    convenience override init() {
        self.init(style: .dark)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
        
    // consider the orientation
    ///
    func updateFontSize(items: [CASMenuItem]) {
        func calculateMinFontSize(initialFontSize: CGFloat, items: [CASMenuItem], label: UILabel) -> CGFloat {
            var innerMinSize: CGFloat = initialFontSize
            for index in 0..<items.count {
                let item = items[index]
                label.text = item.title
                label.font = UIFont.systemFont(ofSize: innerMinSize)
                let tempFontSize = self.nearestFontSize(label: label)
                if (index == 0) {
                    innerMinSize = tempFontSize
                }else if (tempFontSize < innerMinSize) {
                    innerMinSize = tempFontSize
                }
            }
            return innerMinSize
        }
        
        let label = self.normalLabel()
        let rect = CASCommon.shared.currentDeviceAvailableRect()
        var width: CGFloat = 0
        if (self.allInOnePage) {
            let itemCountPerPage: CGFloat = CGFloat(items.count)
            width = rect.width / itemCountPerPage
        }else if (self.itemCountPerPage == 0) {
            width = self.itemWidth
        }else {
            let itemCountPerPage: CGFloat = CGFloat(self.itemCountPerPage)
            width = rect.width / itemCountPerPage
        }
        label.frame = CGRect.init(x: 0, y: 0, width: width, height: self.itemHeight - self.itemSelectedIndicatorSize.height)
        
        var maxFontSize: CGFloat = self.fontSize
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:fallthrough
        case .landscapeRight:
            if self.horizontalMaxFontSize == 0 {
                maxFontSize = calculateMinFontSize(initialFontSize: maxFontSize, items: items, label: label)
                self.horizontalMaxFontSize = maxFontSize
            }else {
                maxFontSize = self.horizontalMaxFontSize
            }
        case .portrait:fallthrough
        case .portraitUpsideDown:fallthrough
        case .unknown:
            if self.verticalMaxFontSize == 0 {
                maxFontSize = calculateMinFontSize(initialFontSize: maxFontSize, items: items, label: label)
                self.verticalMaxFontSize = maxFontSize
            }else {
                maxFontSize = self.verticalMaxFontSize
            }
        }

        var minFontSize: CGFloat = maxFontSize
        for index in 0..<items.count {
            let item = items[index]
            label.text = item.title
            label.font = UIFont.systemFont(ofSize: minFontSize)
            let tempFontSize = self.getApproximateAdjustedFontSize(label: label)
            if (tempFontSize < minFontSize) {
                minFontSize = tempFontSize
            }
        }
        self.fontSize = minFontSize
    }
    
    func fontColor(isSelected: Bool) -> UIColor {
        switch self.style {
        case .dark:
            return isSelected ? kSelectedFontColorOfStyleDark : kUnSelectedFontColorOfStyleDark
        }
    }
    
    func indicatorViewBackgroundColor() -> UIColor {
        switch self.style {
        case .dark:
            return kIndicatorViewColorOfStyleDark
        }
    }
    
    func font(isSelected: Bool) -> UIFont {
        return UIFont.systemFont(ofSize: self.fontSize, weight: isSelected ? .bold : .regular)
    }

    /// call this action when set the frame complete
    func updateUnificationFontSize(label: UILabel) {
        if label.font.pointSize != self.fontSize {
            self.fontSize = label.font.pointSize
        }
    }
    
    var nearestTimes: Int = 0
    func nearestFontSize(label: UILabel) -> CGFloat {
        var currentFont: UIFont = label.font
        let originalFontSize = currentFont.pointSize
        var currentSize: CGSize = ((label.text ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
        if currentSize.width > label.frame.size.width && currentFont.pointSize > (originalFontSize * label.minimumScaleFactor) {
            while currentSize.width > label.frame.size.width && currentFont.pointSize > (originalFontSize * label.minimumScaleFactor) {
                self.nearestTimes += 1
                print("nearestTimes \(self.nearestTimes), font size = \(currentFont.pointSize)")
                currentFont = UIFont.systemFont(ofSize: currentFont.pointSize - 1)
                currentSize = ((label.text ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            }
        }else {
            while currentSize.width < label.frame.size.width {
                self.nearestTimes += 1
                print("nearestTimes \(self.nearestTimes), font size = \(currentFont.pointSize)")
                currentFont = UIFont.systemFont(ofSize: currentFont.pointSize + 1)
                currentSize = ((label.text ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            }
        }
        return currentFont.pointSize
    }

    var approximateTimes: Int = 0
    func getApproximateAdjustedFontSize(label: UILabel) -> CGFloat {
        if label.adjustsFontSizeToFitWidth == true {
            var currentFont: UIFont = label.font
            let originalFontSize = currentFont.pointSize
            var currentSize: CGSize = ((label.text ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            while currentSize.width > label.frame.size.width && currentFont.pointSize > (originalFontSize * label.minimumScaleFactor) {
                self.approximateTimes += 1
                print("approximateTimes \(self.approximateTimes), font size = \(currentFont.pointSize)")
                currentFont = UIFont.systemFont(ofSize: currentFont.pointSize - 1)
                currentSize = ((label.text ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            }
            return currentFont.pointSize
        }
        else {
            return label.font.pointSize
        }
    }
    
    func normalLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: self.fontSize)
        label.textAlignment = .center
        label.numberOfLines = 1 // designer confirmed
        label.adjustsFontSizeToFitWidth = self.useUnificationFontSize
        return label
    }
}

private class CASMenuItemView: UICollectionViewCell {
    private var adapter: CASMenuListAdapter = CASMenuListAdapter()
    private var titleLabel: UILabel?
    private var indicatorView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    func configurateWith(adapter: CASMenuListAdapter, item: CASMenuItem?) {
        self.adapter = adapter
        setup(adapter: adapter, item: item)
    }
    
    private func setup(adapter: CASMenuListAdapter, item: CASMenuItem?) {
        if self.titleLabel == nil {
            let label = adapter.normalLabel()
            label.text = item?.title
            label.textColor = self.adapter.fontColor(isSelected: self.isSelected)
            self.contentView.addSubview(label)
            self.titleLabel = label
            self.titleLabel?.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.leading.equalToSuperview().offset(adapter.kItemLabelTrailingAndLeadingGap)
                make.trailing.equalToSuperview().offset(-adapter.kItemLabelTrailingAndLeadingGap)
            }
        }else {
            self.titleLabel?.text = item?.title
            self.titleLabel?.textColor = self.adapter.fontColor(isSelected: self.isSelected)
        }
        
        if self.indicatorView == nil {
            let indicatorView = UIView()
            indicatorView.backgroundColor = self.adapter.indicatorViewBackgroundColor()
            indicatorView.isHidden = !self.isSelected
            self.contentView.addSubview(indicatorView)
            self.indicatorView = indicatorView
            self.indicatorView?.snp.makeConstraints { (make) in
                make.size.equalTo(adapter.itemSelectedIndicatorSize)
                make.centerX.bottom.equalToSuperview()
            }
        }else {
            self.indicatorView?.backgroundColor = self.adapter.indicatorViewBackgroundColor()
            self.indicatorView?.isHidden = !self.isSelected
        }
    }
    
    private func updateUI() {
        self.titleLabel?.font = self.adapter.font(isSelected: self.isSelected)
        self.titleLabel?.textColor = self.adapter.fontColor(isSelected: self.isSelected)
        self.indicatorView?.isHidden = !self.isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
}

class CASMenuListView: UIView {
    var adapter: CASMenuListAdapter!
    var items: [CASMenuItem]?
    var selectedIndex: Int = 0
    var selectActionClosure: ((CASMenuItem)->Void)?
    private var collectionView: UICollectionView!
    private var itemSize: CGSize = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup(adapter: CASMenuListAdapter())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup(adapter: CASMenuListAdapter())
    }
    
    init(adapter: CASMenuListAdapter, items: [CASMenuItem]) {
        super.init(frame: CGRect.zero)
        self.items = items
        self.setup(adapter: adapter)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(type(of: self)) deinit")
    }
    
    private func setup(adapter: CASMenuListAdapter) {
        self.adapter = adapter
        self.updateFontSize()
        self.updateItemSize()
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout())
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = (adapter.allInOnePage == false) && (adapter.itemCountPerPage == 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CASMenuItemView.self, forCellWithReuseIdentifier: adapter.kCellReuseID)
        
        self.collectionView = collectionView
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        collectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChanged(sender:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    private func updateFontSize() {
        if adapter.useUnificationFontSize {
            self.adapter.updateFontSize(items: self.items ?? [CASMenuItem]())
        }
    }
    
    private func updateItemSize() {
        var itemSize: CGSize = .zero
        let rect = CASCommon.shared.currentDeviceAvailableRect()
        if self.adapter.allInOnePage {
            itemSize = CGSize.init(width: rect.width / CGFloat(self.items?.count ?? 1), height: self.adapter.itemHeight)
        }else if self.adapter.itemCountPerPage == 0 {
            itemSize = CGSize.init(width: self.adapter.itemWidth, height: self.adapter.itemHeight)
        }else {
            itemSize = CGSize.init(width: rect.width / CGFloat(self.adapter.itemCountPerPage), height: self.adapter.itemHeight)
        }
        self.itemSize = itemSize
    }
    
    @objc private func statusBarOrientationChanged(sender: Notification) {
        self.updateFontSize()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.collectionView.collectionViewLayout = self.flowLayout()
            self.collectionView.reloadData()
        }
    }
    
    private func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = self.itemSize
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.sectionInset = UIEdgeInsets.zero
        if #available(iOS 9.0, *) {
            layout.sectionHeadersPinToVisibleBounds = false
            layout.sectionFootersPinToVisibleBounds = false
        }
        return layout
    }
}

// MARK: collection delegate, dataSource
extension CASMenuListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.adapter.kCellReuseID, for: indexPath)
        if let cell = cell as? CASMenuItemView {
            cell.configurateWith(adapter: self.adapter, item: self.items?[indexPath.row])
            if self.selectedIndex == indexPath.row {
                cell.isSelected = true
            }else {
                cell.isSelected = false
            }
        }
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select index = \(indexPath)")
        let cell = collectionView.cellForItem(at: IndexPath.init(row: self.selectedIndex, section: 0))
        if cell?.isSelected == true {
            cell?.isSelected = false
        }
        self.selectedIndex = indexPath.row
        let counts: Int = self.items?.count ?? 0
        if counts > indexPath.row, let item = self.items?[indexPath.row] {
            self.selectActionClosure?(item)
        }else {
            print("occur errors, index out of range.")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("de-select index = \(indexPath)")
    }
    
    // flowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
}

