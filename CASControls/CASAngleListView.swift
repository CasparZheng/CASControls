//
//  CASAngleListView.swift
//  ARVControlsDemo
//
//  Created by Caspar on 3/27/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import UIKit

@objc(CASAngleStyle)
enum CASAngleStyle: Int {
    case dark
}

@objc(CASOverWordsSolution)
enum CASOverWordsSolution: Int {
    case automaticllyIncrease // increase item height
    case adjustFontSize // change label font size
}

class CASAngleItem: NSObject {
    var title: String = ""
    var imageName: String = ""
    
    convenience override init() {
        self.init(title: "", imageName: "")
    }
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

class CASAngleListAdapter: NSObject {
    typealias Style = CASAngleStyle
    typealias OverWordsSolution = CASOverWordsSolution
    
    var style: Style = .dark
    var overWordsSolution: OverWordsSolution = .automaticllyIncrease
    // whether use the unification font size, if set true, will update fontSize property automatically
    var automaticResizeItemHeight: Bool = true
    var fontSize: CGFloat = 10.0
    
    var imageViewSize: CGSize = CGSize.init(width: 96.0, height: 56.0)
    var labelSize: CGSize = CGSize.init(width: 96.0, height: 20)
    
    private let kSelectedFontColorOfStyleDark = UIColor.white
    private let kUnSelectedFontColorOfStyleDark = UIColor.init(white: 1.0, alpha: 0.55)
    private let kImageViewBackgroundColorOfStyleDark = UIColor.init(red: 0x1Ap0 / 0xFFp0, green: 0x1Ap0 / 0xFFp0, blue: 0x1Ap0 / 0xFFp0, alpha: 1.0) // 0xFFD200
    private let kSelectedImageViewBorderColorOfStyleDark = UIColor.init(red: 0xFFp0 / 0xFFp0, green: 0xD2p0 / 0xFFp0, blue: 0x00p0 / 0xFFp0, alpha: 1.0) // 0xFFD200
    let kSelectedImageViewBorderWidth: CGFloat = 2.0
    let kImageViewCornerRadius: CGFloat = 4.0
    let kItemImageAndLabelGap: CGFloat = 8
    let kItemsGap: CGFloat = 16
    let kItemsCollectionViewEdgeInsets: UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
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
    
    func calculateItemSize(items: [CASAngleItem]) -> CGSize {
        if items.count == 0 {
            return CGSize.zero
        }
        switch self.overWordsSolution {
        case .automaticllyIncrease:
            let label = self.normalLabel()
            var maxLabelSize: CGSize = CGSize.init(width: self.imageViewSize.width, height: 0)
            for item in items {
                label.text = item.title
                label.adjustsFontSizeToFitWidth = false
                let titleSize = label.sizeThatFits(CGSize.init(width: self.imageViewSize.width, height: 1000)) // set height value 1000
                if maxLabelSize.height < titleSize.height {
                    maxLabelSize.height = titleSize.height
                }
            }
            let itemSize = CGSize.init(width: self.imageViewSize.width, height: self.imageViewSize.height + self.kItemImageAndLabelGap + maxLabelSize.height)
            return itemSize
        case .adjustFontSize:
            let itemSize = CGSize.init(width: self.imageViewSize.width, height: self.imageViewSize.height + self.kItemImageAndLabelGap + self.labelSize.height)
            return itemSize
        }
    }
    
    func fontColor(isSelected: Bool) -> UIColor {
        switch self.style {
        case .dark:
            return UIColor.white
        }
    }
    
    /// selected color
    func imageBorderColor(isSelected: Bool) -> UIColor {
        switch self.style {
        case .dark:
            return isSelected ? kSelectedImageViewBorderColorOfStyleDark : UIColor.clear
        }
    }
    
    func imageBackgroundColor(isSelected: Bool) -> UIColor {
        switch self.style {
        case .dark:
            return kImageViewBackgroundColorOfStyleDark
        }
    }
    
    func normalLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: self.fontSize)
        label.textAlignment = .center
        label.numberOfLines = 0 // can stretch
        label.adjustsFontSizeToFitWidth = (self.overWordsSolution == .adjustFontSize)
        return label
    }
}

private class CASAngleItemView: UICollectionViewCell {
    private var adapter: CASAngleListAdapter = CASAngleListAdapter()
    private var titleLabel: UILabel?
    private var imageView: UIImageView?

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

    func configurateWith(adapter: CASAngleListAdapter, item: CASAngleItem?) {
        self.adapter = adapter
        self.titleLabel?.snp.removeConstraints()
        self.imageView?.snp.removeConstraints()
        self.titleLabel?.removeFromSuperview()
        self.imageView?.removeFromSuperview()
        self.titleLabel = nil
        self.imageView = nil
        setup(adapter: adapter, item: item)
    }

    private func setup(adapter: CASAngleListAdapter, item: CASAngleItem?) {
        
        let label = adapter.normalLabel()
        label.text = item?.title
        label.textColor = self.adapter.fontColor(isSelected: self.isSelected)

        let imageView = UIImageView()
        let imageName: String = item?.imageName ?? ""
        imageView.image = UIImage.init(named: imageName)
        imageView.backgroundColor = adapter.imageBackgroundColor(isSelected: self.isSelected)
        imageView.layer.borderColor = adapter.imageBorderColor(isSelected: self.isSelected).cgColor
        imageView.layer.borderWidth = self.isSelected ? adapter.kSelectedImageViewBorderWidth : 0
        imageView.layer.cornerRadius = adapter.kImageViewCornerRadius
        imageView.layer.masksToBounds = true
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(imageView)

        self.titleLabel = label
        self.imageView = imageView

        self.titleLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView!.snp.bottom).offset(adapter.kItemImageAndLabelGap)
            make.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        self.imageView?.snp.makeConstraints { (make) in
            make.size.equalTo(adapter.imageViewSize)
            make.centerX.top.equalToSuperview()
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(adapter.imageViewSize.height)
        }
    }

    private func updateUI() {
        self.imageView?.layer.borderColor = self.adapter.imageBorderColor(isSelected: self.isSelected).cgColor
        self.imageView?.layer.borderWidth = self.isSelected ? self.adapter.kSelectedImageViewBorderWidth : 0
    }

    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
}

class CASAngleListView: UIView {
    var adapter: CASAngleListAdapter!
    var items: [CASAngleItem]?
    var selectedIndex: Int = 0
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup(adapter: CASAngleListAdapter())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup(adapter: CASAngleListAdapter())
    }
    
    init(adapter: CASAngleListAdapter, items: [CASAngleItem]) {
        super.init(frame: CGRect.zero)
        self.items = items
        self.setup(adapter: adapter)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    private func setup(adapter: CASAngleListAdapter) {
        self.adapter = adapter
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CASAngleItemView.self, forCellWithReuseIdentifier: adapter.kCellReuseID)
        
        self.collectionView = collectionView
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        collectionView.reloadData()
    }
    
    private func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.adapter.kItemsGap
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.adapter.calculateItemSize(items: self.items ?? [CASAngleItem]())
        layout.scrollDirection = .horizontal
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.sectionInset = self.adapter.kItemsCollectionViewEdgeInsets
        if #available(iOS 9.0, *) { // both default are false
            layout.sectionHeadersPinToVisibleBounds = false
            layout.sectionFootersPinToVisibleBounds = false
        }
        return layout
    }
}

// MARK: collection delegate, dataSource
extension CASAngleListView: UICollectionViewDelegate, UICollectionViewDataSource {
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let counts: Int = self.items?.count ?? 0
        return counts
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.adapter.kCellReuseID, for: indexPath)
        if let cell = cell as? CASAngleItemView {
            cell.configurateWith(adapter: self.adapter, item: self.items?[indexPath.row])
            if self.selectedIndex == indexPath.row {
                cell.isSelected = true
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
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("de-select index = \(indexPath)")
    }
}

