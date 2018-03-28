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
        addAngleList()
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
}

