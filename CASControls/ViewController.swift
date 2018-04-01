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
        addCheckboxList()
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

