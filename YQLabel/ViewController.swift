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
        
        
//        self.label.add(text: "洪七公", color: UIColor.blue)
//        self.label.add(text: "回复", color: UIColor.red)
//        self.label.add(text: "欧阳康", color: UIColor.green,  clickHandler: {(text, tag) in
//            print("点击了 \(text)")
//        })
//        self.label.add(text: "死鬼 死鬼 死鬼 哦哈哈哈 😂 A bc 哦哈哈哈 😂 A bc")
//        self.label.add(text: "点我😂😂", clickHandler: {(text, tag) -> Void in
//            print("点的我好爽啊")
//        })
//        self.label.add(text: "😂😂", clickHandler: {(text, tag) -> Void in
//            print("点的我好爽啊")
//        })
        self.label.add(text: "我有葵花宝典你想练吗", color: UIColor.red, clickHandler: {(text, tag) -> Void in
            print(text)
        })
        self.label.add(text: "😂\u{200B}😂\u{200B}", color: UIColor.green ,clickHandler: {(text, tag) -> Void in
            print("点的我好爽啊")
        })
        self.label.add(text: "九阴真经", color: UIColor.red, clickHandler: {(text, tag) -> Void in
            print(text)
        })
//        self.label.add(text: "我有葵花宝典你想练吗", color: UIColor.red, clickHandler: {(text, tag) -> Void in
//            print(text)
//        })
        self.label.add(text: "《XX授权书》", tag: 33, color: UIColor.gray) { (text, tag) in
            print("点击了 \(text)  \(tag)")
        }
        self.label.add(text: "《XXX授权书》", tag: 34, color: UIColor.gray) { (text, tag) in
            print("点击了 \(text)  \(tag)")
        }
        self.label.flash()

       
    }

    @IBOutlet weak var label: YQLabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

