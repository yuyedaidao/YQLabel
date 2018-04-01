# YQLabel
Swift富文本Label,可点击

![pic](https://raw.githubusercontent.com/yuyedaidao/YQLabel/master/yoyo.jpg)

## Installation
### Carthage
```
github "yuyedaidao/YQLabel" 
```
### Cocoapods
看心情吧

## Use
```
let label = YQLabel()
view.addSubview(label)
// layout        
label.add(text: "洪七公", color: UIColor.blue)
label.add(text: "回复", color: UIColor.red)
label.add(text: "欧阳康", color: UIColor.green,  clickHandler: {(text, tag) in
    print("点击了 \(text)")
})
// ...
label.add(text: "点我😂😂", clickHandler: {(text, tag) -> Void in
    print("点的我好爽啊")
})
label.flash()
```

## TODO
+ [ ] 处理带emoji的文本出现点击出现错落的问题
