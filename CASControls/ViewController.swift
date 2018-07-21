//
//  ViewController.swift
//  ARVControlsDemo
//
//  Created by Caspar on 3/20/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        addMenuList()
//        addAngleList()
//        addCheckboxList()
//        addNavigationBarView()
//        testNavigationItem()
        addAlignView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addAlignView() {
        
        // both images and titles
        let alignView = CASAlignView.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 100))
        alignView.imagePosition = .bottom
        alignView.backgroundColor = UIColor.green
        alignView.addImage(image: UIImage.init(named: "back_icon"), action: nil, actionType: .none)
        alignView.addImage(image: UIImage.init(named: "back_icon"), action: nil, actionType: .none)
        alignView.addImage(image: UIImage.init(named: "back_icon"), action: nil, actionType: .none)
        alignView.addTitle(title: "Beijing", action: { (gestureType) in
            print("\(gestureType)")
        }, actionType: .tap)
        alignView.addTitle(title: "Shenzhen", action: nil, actionType: .none)
        self.view.addSubview(alignView)
        
        
        // only images
        let alignView2 = CASAlignView.init(frame: CGRect.init(x: 100, y: 250, width: 200, height: 100))
        alignView2.backgroundColor = UIColor.green
        alignView2.imagesAlignDirection = .horizontal
        alignView2.imagePosition = .bottom
        alignView2.addImage(image: UIImage.init(named: "back_icon"), action: nil, actionType: .none)
        alignView2.addImage(image: UIImage.init(named: "back_icon"), action: nil, actionType: .none)
        alignView2.addImage(image: UIImage.init(named: "back_icon"), action: nil, actionType: .none)
        self.view.addSubview(alignView2)


        // only titles
        let alignView3 = CASAlignView.init(frame: CGRect.init(x: 100, y: 400, width: 200, height: 100))
        alignView3.backgroundColor = UIColor.green
        alignView3.addTitle(title: "Shenzhen", action: nil, actionType: .none)
        alignView3.addTitle(title: "Beijing", action: nil, actionType: .none)
        alignView3.addTitle(title: "Shanghai", action: nil, actionType: .none)
        self.view.addSubview(alignView3)
    }
    
    func addNavigationBarView() {
        func createButton(title: String?) -> UIButton {
            let button = UIButton.init(type: UIButtonType.custom)
            button.setTitle("beijing", for: UIControlState.normal)
            button.addTarget(self, action: #selector(navigationBarViewItemsAction(_:)), for: UIControlEvents.touchUpInside)
            return button
        }
        self.navigationController?.navigationBar.isHidden = true
        let navigationBarView = CASNavigationBarView.init(height: 128)
        navigationBarView.title = "beijing"
        navigationBarView.prompt = "I come from China, where are u from"
        navigationBarView.backgroundColor = UIColor.green
        let buttonLeft1 = createButton(title: "xizang")
        let buttonLeft2 = createButton(title: "xinjiang")
        let buttonLeft3 = createButton(title: "sichuan")
        let buttonLeft4 = createButton(title: "guizhou")
        let buttonLeft5 = createButton(title: "yunnan")
        let buttonLeft6 = createButton(title: "qinghai")
        
        let buttonRight1 = createButton(title: "beijing")
        let buttonRight2 = createButton(title: "shanghai")
        let buttonRight3 = createButton(title: "zhejiang")
        let buttonRight4 = createButton(title: "fujian")
        let buttonRight5 = createButton(title: "guangzhou")
        let buttonRight6 = createButton(title: "jiangxi")
        
        navigationBarView.leftBarButtonItems = [
            buttonLeft1,
            buttonLeft2,
            buttonLeft3,
            buttonLeft4,
            buttonLeft5,
            buttonLeft6,
        ]
        navigationBarView.rightBarButtonItems = [
            buttonRight1,
            buttonRight2,
            buttonRight3,
            buttonRight4,
            buttonRight5,
            buttonRight6,
        ]
        
        self.view.addSubview(navigationBarView)
    }
    @objc func navigationBarViewItemsAction(_ item: UIButton) {
        print("click item: \(item.titleLabel?.text as Any)")
    }
    func testNavigationItem() {
        self.navigationItem.prompt = "beijingbeijing"
        self.navigationItem.title = "1123945"
//        let label = UILabel()
//        label.text = "shenzhen"
//        label.sizeToFit()
//        self.navigationItem.titleView = label
        self.navigationItem.leftItemsSupplementBackButton = false
        let buttonLeft1 = UIBarButtonItem.init(title: "xizang", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonLeft2 = UIBarButtonItem.init(title: "xinjiang", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonLeft3 = UIBarButtonItem.init(title: "qinghai", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonLeft4 = UIBarButtonItem.init(title: "neimenggu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonLeft5 = UIBarButtonItem.init(title: "shanxi", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        
        let buttonRight1 = UIBarButtonItem.init(title: "shanghai", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonRight2 = UIBarButtonItem.init(title: "zhejiang", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonRight3 = UIBarButtonItem.init(title: "fujian", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonRight4 = UIBarButtonItem.init(title: "guangzhou", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        let buttonRight5 = UIBarButtonItem.init(title: "yunnan", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        
        self.navigationItem.leftBarButtonItems = [
            buttonLeft1,
            buttonLeft2,
            buttonLeft3,
            buttonLeft4,
        ]
        self.navigationItem.rightBarButtonItems = [
            buttonRight1,
            buttonRight2,
            buttonRight3,
            buttonRight4,
            buttonRight5,
        ]
        self.navigationItem.backBarButtonItem = buttonLeft5
        print("left item: \(self.navigationItem.leftBarButtonItem as Any)")
        print("back item: \(self.navigationItem.backBarButtonItem as Any)")
        print("items: \(self.navigationItem.leftBarButtonItems as Any)")
        
        let newVc: UIViewController = UIViewController()
        newVc.view.backgroundColor = UIColor.green
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dissmiss(_:)))
        newVc.view.addGestureRecognizer(tap)
        newVc.navigationItem.leftItemsSupplementBackButton = false
        newVc.navigationItem.backBarButtonItem = buttonRight5
        newVc.navigationItem.leftBarButtonItems = [buttonLeft1, buttonLeft2]
        self.navigationController?.pushViewController(newVc, animated: true)
    }
    
    @objc private func leftBarButtonItemAction(_ item: UIBarButtonItem) {
        print("click: \(item.title as Any)")
    }
    @objc private func dissmiss(_ tap: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func addAngleList() {
        let item1 = CASAngleItem.init(title: "First", imageName: "sharepage_ic_visualchoice04")
        let item2 = CASAngleItem.init(title: "Second, Second, Second, Second, Second, Second, Second", imageName: "sharepage_ic_visualchoice04")
        let item3 = CASAngleItem.init(title: "Third\nThird\nThird", imageName: "sharepage_ic_visualchoice04")
        let item4 = CASAngleItem.init(title: "Fourth", imageName: "sharepage_ic_visualchoice04")
        let item5 = CASAngleItem.init(title: "Fiveth", imageName: "sharepage_ic_visualchoice04")
        let adapter = CASAngleListAdapter.init()
        adapter.overWordsSolution = .adjustFontSize
        let list = CASAngleListView.init(adapter: adapter, items: [item1, item2, item3, item4, item5])
        self.view.addSubview(list)
        list.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(100)
        }
    }
    
    
    
    func addMenuList() {
        let item = CASMenuItem.init(title: "First, First, First, First, First, First, First, First, First")
        let item2 = CASMenuItem.init(title: "Second, Second, Second, Second, Second, Second, Second, Second, Second, Second")
        let adapter = CASMenuListAdapter.init(style: .dark)
        adapter.useUnificationFontSize = true
        let list = CASMenuListView.init(adapter: adapter, items: [item, item2])
        self.view.addSubview(list)
        list.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalToSuperview().offset(100)
        }
    }
    
    func addCheckboxList() {
        let item1Range1 = NSRange.init(location: 0, length: "First".lengthOfBytes(using: .utf8))
        let item1Range2 = NSRange.init(location: "First, Second, ".lengthOfBytes(using: .utf8), length: "Third".lengthOfBytes(using: .utf8))
        let item1Closure1: CASCheckBoxItem.TapClosure = { (title) in
            print("select title = \(title)")
        }
        let item1Closure2: CASCheckBoxItem.TapClosure = { (title) in
            print("select title = \(title)")
        }
        let item1 = CASCheckBoxItem.init(title: "First, Second, Third, Fourth, Fiveth, sixth, seventh, eighth, nineth, tenth \n gap \n First, Second, Third, Fourth, Fiveth, sixth, seventh, eighth, nineth, tenth",
                                        ranges: [item1Range1, item1Range2],
                                        rangeClosures: [item1Closure1, item1Closure2])
        
        let item2Range1 = NSRange.init(location: 0, length: "First".lengthOfBytes(using: .utf8))
        let item2Range2 = NSRange.init(location: "First, Second, ".lengthOfBytes(using: .utf8), length: "Third".lengthOfBytes(using: .utf8))
        let item2Closure1: CASCheckBoxItem.TapClosure = { (title) in
            print("select title = \(title)")
        }
        let item2Closure2: CASCheckBoxItem.TapClosure = { (title) in
            print("select title = \(title)")
        }
        let item2 = CASCheckBoxItem.init(title: "First, Second, Third, Fourth, Fiveth",
                                        ranges: [item2Range1, item2Range2],
                                        rangeClosures: [item2Closure1, item2Closure2])

        
        let adapter = CASCheckBoxListAdapter.init(style: .dark)
        let list = CASCheckBoxListView.init(adapter: adapter, items: [item1, item2])
        self.view.addSubview(list)
        list.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
            make.top.equalToSuperview().offset(100)
        }
    }
}

