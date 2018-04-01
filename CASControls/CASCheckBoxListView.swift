//
//  CASCheckBoxListView.swift
//  CASControls
//
//  Created by Caspar on 3/31/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import UIKit
import TTTAttributedLabel

private let kTransitionInfoKey = "kTransitionInfoKey"

@objc(CASCheckBoxStyle)
enum CASCheckBoxStyle: Int {
    case dark
}

class CASCheckBoxItem: NSObject {
    typealias TapClosure = (String)->Void
    
    private(set) var title: String = ""
    private(set) var highLightRanges: [NSRange] = [NSRange]()
    private(set) var highLightClosures: [TapClosure] = [TapClosure]()
    var isConfirmed: Bool = false
    
    init(title: String, ranges: [NSRange]?, rangeClosures: [TapClosure]?) {
        self.title = title
        if let ranges = ranges, let closures = rangeClosures, ranges.count == closures.count {
            highLightRanges = ranges
            highLightClosures = closures
        }
    }
}



class CASCheckBoxListAdapter: NSObject {
    typealias Style = CASCheckBoxStyle
    
    var style: Style = .dark
    // whether use the unification font size, if set true, will update fontSize property automatically
    var useUnificationFontSize: Bool = false
    var fontSize: CGFloat = 12.0
    
    private let kHighlightedFontColorOfStyleDark = UIColor.white
    private let kUnHighlightedFontColorOfStyleDark = UIColor.white
    private var verticalMaxFontSize: CGFloat = 0 // inner stored for update fontSize
    private var horizontalMaxFontSize: CGFloat = 0 // inner stored for update fontSize
    private let kConfirmedImageName = "sharepage_ic_checkbox_a"
    private let kUnConfirmedImageName = "sharepage_ic_checkbox_n"
    
    let kItemImageViewSize = CGSize.init(width: 14, height: 14)
    let kItemNormalGap: CGFloat = 8
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
    
    func fontColor(isHighlighted: Bool) -> UIColor {
        switch self.style {
        case .dark:
            return isHighlighted ? kHighlightedFontColorOfStyleDark : kUnHighlightedFontColorOfStyleDark
        }
    }
    
    func imageViewName(isConfirmed: Bool) -> String {
        switch self.style {
        case .dark:
            return isConfirmed ? kConfirmedImageName : kUnConfirmedImageName
        }
    }
    
    func font(isHighlighted: Bool) -> UIFont {
        return UIFont.systemFont(ofSize: self.fontSize, weight: isHighlighted ? .bold : .regular)
    }
    
    func itemSize(item: CASCheckBoxItem, inWidth: CGFloat) -> CGSize {
        let label = self.tttLabel(item: item)
        // horizontal layout rule: gap + imageWidth + gap + labelWidth + gap
        // vertical layout rule: max(gap + imageHeight + gap, gap + labelHeight + gap)
        let imageAndOthersWidth: CGFloat = self.kItemImageViewSize.width + self.kItemNormalGap * 3
        let maxLabelWidth: CGFloat = inWidth - imageAndOthersWidth
        let labelSize = label.sizeThatFits(CGSize.init(width: maxLabelWidth, height: 1000))
        let height: CGFloat = max(labelSize.height, self.kItemImageViewSize.height)
        return CGSize.init(width: inWidth, height: height + self.kItemNormalGap * 2)
    }
    
    func tttLabel(item: CASCheckBoxItem) -> TTTAttributedLabel {
        let label = TTTAttributedLabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: self.fontSize)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        let attributeString = NSAttributedString.init(string: item.title, attributes: [NSAttributedStringKey.font : self.font(isHighlighted: false),
                                                                                       NSAttributedStringKey.foregroundColor : self.fontColor(isHighlighted: false)])
        label.setText(attributeString)
        label.linkAttributes = [NSAttributedStringKey.font : self.font(isHighlighted: true),
                                NSAttributedStringKey.foregroundColor : self.fontColor(isHighlighted: true)]
        label.textColor = self.fontColor(isHighlighted: item.isConfirmed)
        for index in 0..<item.highLightRanges.count {
            let range = item.highLightRanges[index]
            let component = String.init(format: "%d", index)
            label.addLink(toTransitInformation: [kTransitionInfoKey : component], with: range)
        }

        return label
    }
}

private class CASCheckBoxItemView: UICollectionViewCell {
    private var imageView: UIImageView?
    private var titleLabel: TTTAttributedLabel?
    private var item: CASCheckBoxItem?
    private var adapter: CASCheckBoxListAdapter = CASCheckBoxListAdapter()
    private var isConfirmed: Bool = false
    
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
    
    func configurateWith(adapter: CASCheckBoxListAdapter, item: CASCheckBoxItem?) {
        self.adapter = adapter
        self.item = item
        self.isConfirmed = item?.isConfirmed ?? false
        setup(adapter: adapter, item: item)
    }
    
    private func setup(adapter: CASCheckBoxListAdapter, item: CASCheckBoxItem?) {
        if self.imageView == nil {
            let imageName = self.adapter.imageViewName(isConfirmed: self.isConfirmed)
            let imageView = UIImageView.init(image: UIImage.init(named: imageName))
            self.imageView = imageView
            self.contentView.addSubview(imageView)
            self.imageView?.snp.makeConstraints { (make) in
                make.size.equalTo(adapter.kItemImageViewSize)
                make.leading.equalToSuperview().offset(adapter.kItemNormalGap)
                make.top.equalToSuperview().offset(adapter.kItemNormalGap)
            }
            
            let tapContainer = UIView() // large then response area
            tapContainer.backgroundColor = UIColor.clear
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(confirmValueChange(sender:)))
            tapContainer.addGestureRecognizer(tapGesture)
            self.contentView.addSubview(tapContainer)
            tapContainer.snp.makeConstraints({ (make) in
                make.top.leading.equalTo(imageView).offset(-adapter.kItemNormalGap)
                make.bottom.right.equalTo(imageView).offset(adapter.kItemNormalGap)
            })
            self.sendSubview(toBack: tapContainer)
            
        }else {
            let imageName = self.adapter.imageViewName(isConfirmed: self.isConfirmed)
            self.imageView?.image = UIImage.init(named: imageName)
        }
        
        if self.titleLabel == nil, let item = self.item {
            let label = adapter.tttLabel(item: item)
            label.delegate = self
            self.titleLabel = label
            self.contentView.addSubview(label)
            self.titleLabel?.snp.makeConstraints { (make) in
                make.leading.equalTo(self.imageView!.snp.trailing).offset(adapter.kItemNormalGap)
                make.top.equalTo(self.imageView!)
                make.trailing.equalToSuperview().offset(-adapter.kItemNormalGap)
            }
        }else {
            self.titleLabel?.text = item?.title
            self.titleLabel?.textColor = self.adapter.fontColor(isHighlighted: self.isConfirmed)
        }
    }
    
    private func updateUI() {
        let imageName = self.adapter.imageViewName(isConfirmed: self.isConfirmed)
        self.imageView?.image = UIImage.init(named: imageName)
    }
    
    @objc private func confirmValueChange(sender: UITapGestureRecognizer) {
        self.isConfirmed = !self.isConfirmed
        self.item?.isConfirmed = self.isConfirmed
        updateUI()
    }
}

extension CASCheckBoxItemView: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithTransitInformation components: [AnyHashable : Any]!) {
        if let value = components[kTransitionInfoKey] as? String, let index = Int.init(value), let item = self.item {
            let closure = item.highLightClosures[index]
            let range = item.highLightRanges[index]
            let title = NSString.init(string: item.title).substring(with: range)
            closure(title)
        }
    }
}


class CASCheckBoxListView: UIView {
    var adapter: CASCheckBoxListAdapter!
    var items: [CASCheckBoxItem]?
    
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup(adapter: CASCheckBoxListAdapter())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup(adapter: CASCheckBoxListAdapter())
    }
    
    init(adapter: CASCheckBoxListAdapter, items: [CASCheckBoxItem]) {
        super.init(frame: CGRect.zero)
        self.items = items
        self.setup(adapter: adapter)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(type(of: self)) deinit")
    }
    
    private func setup(adapter: CASCheckBoxListAdapter) {
        self.adapter = adapter
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CASCheckBoxItemView.self, forCellWithReuseIdentifier: adapter.kCellReuseID)
        
        self.collectionView = collectionView
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        collectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChanged(sender:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    @objc private func statusBarOrientationChanged(sender: Notification) {
        self.collectionView.reloadData()
    }
    
    private func flowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.zero
        layout.scrollDirection = .vertical
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
extension CASCheckBoxListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.adapter.kCellReuseID, for: indexPath)
        if let cell = cell as? CASCheckBoxItemView {
            cell.configurateWith(adapter: self.adapter, item: self.items?[indexPath.row])
        }
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.items?[indexPath.row] {
            return self.adapter.itemSize(item: item, inWidth: self.collectionView.bounds.width)
        }
        return CGSize.zero
    }
}
