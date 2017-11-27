//
//  ViewController.swift
//  YQLabel
//
//  Created by 王叶庆 on 2017/11/26.
//  Copyright © 2017年 王叶庆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = YQLabel()
        view.addSubview(label)
        
        label.add(text: "洪七公", color: UIColor.blue)
        label.add(text: "回复", color: UIColor.red)
        label.add(text: "欧阳康", color: UIColor.green,  clickHandler: {(text, tag) in
            print("点击了 \(text)")
        })
        label.add(text: "死鬼 死鬼 死鬼 哦哈哈哈 😂 A bc 哦哈哈哈 😂 A bc")
        label.add(text: "点我😂😂", clickHandler: {(text, tag) -> Void in
            print("点的我好爽啊")
        })
        label.flash()

    }

    @IBOutlet weak var label: YQLabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

