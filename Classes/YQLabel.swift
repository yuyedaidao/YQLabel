//
//  YQLabel.swift
//  YQLabel
//
//  Created by 王叶庆 on 2017/11/26.
//  Copyright © 2017年 王叶庆. All rights reserved.
//

import UIKit

public typealias YQTextClickHandler =  (String, Int) -> Void

struct StringParagraph: Equatable {
    static func ==(lhs: StringParagraph, rhs: StringParagraph) -> Bool {
        return lhs.location == rhs.location && lhs.text == rhs.text && lhs.tag == rhs.tag
    }
    
    let text: String
    let tag: Int
    let color: UIColor?
    let clickHandler: YQTextClickHandler?
    let location: Int
    func range() -> Range<Int> {
        return location ..< (location + text.count)
    }
}

struct YQRect: Hashable {
    
    static func ==(lhs: YQRect, rhs: YQRect) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    let value: CGRect
    
    var hashValue: Int {
        var hash =  0
        hash = hash ^ value.origin.x.hashValue
        hash = hash ^ value.origin.y.hashValue
        hash = hash ^ value.width.hashValue
        hash = hash ^ value.height.hashValue
        return hash
    }
}

@IBDesignable

public class YQLabel: UIView {

    @IBInspectable public var textColor: UIColor = UIColor.darkText
    @IBInspectable public var highlightedColor: UIColor = UIColor.lightGray
    @IBInspectable public var font: UIFont = UIFont.systemFont(ofSize: 15)
    @IBInspectable public var lineSpace: CGFloat = 4
    @IBInspectable public var text: String? {
        didSet {
            texts = []
            flash()
        }
    }
    
    fileprivate var isTouching: Bool = false
    fileprivate var touchedParagraph: StringParagraph?
    fileprivate var touchedDate: Date!
    fileprivate var texts: [StringParagraph] = []
    
    fileprivate var drawText: NSAttributedString? {
        var text = texts.reduce(NSMutableAttributedString()) { (result, paragraph) -> NSMutableAttributedString in
            var attributes: [NSAttributedStringKey : Any] =  [NSAttributedStringKey.font: self.font]
            if let color = paragraph.color {
                attributes[NSAttributedStringKey.foregroundColor] = color
            } else {
                attributes[NSAttributedStringKey.foregroundColor] = textColor
            }
            if let touchedParagraph = self.touchedParagraph {
                if isTouching && nil != paragraph.clickHandler && touchedParagraph == paragraph{
                    attributes[NSAttributedStringKey.backgroundColor] = highlightedColor
                }
            }
            result.append(NSAttributedString(string: paragraph.text, attributes: attributes))
            return result
        }
        guard text.string.isEmpty, let string = self.text else {
            return text
        }
        text = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor])
        return text
    }
    
    fileprivate var rects: [YQRect : Int] = [:]
    
    public func add(text: String, tag: Int = Int.max, color: UIColor? = nil, clickHandler: YQTextClickHandler? = nil) {
        var location: Int = 0
        if let last = texts.last {
            location = last.range().upperBound
        }
        texts.append(StringParagraph(text: text, tag: tag, color: color, clickHandler: clickHandler, location: location))
    }
    
    public func clear() {
        text = nil
        flash()
    }
    
    public func flash() {
        invalidateIntrinsicContentSize()
        setNeedsDisplay()
    }

    override public func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        guard let attributedText = drawText else {
            return
        }
        context.setStrokeColor(textColor.cgColor)
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1, y: -1)
        
        let assumeRect = CGRect(x: 0, y: 0, width: bounds.width, height: 10000)
        let path = CGMutablePath()
        path.addRect(assumeRect)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
        let lines = CTFrameGetLines(frame) as! Array<CTLine>
        var lineOrigins: [CGPoint] = [CGPoint](repeating: CGPoint.zero, count: lines.count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        
        var originY: CGFloat = 0
        let lineHeight = font.lineHeight + lineSpace
        
        var rects: [YQRect : Int] = [:]
        
        for (i, line) in lines.enumerated() {
            var lineAscent = CGFloat()
            var lineDescent = CGFloat()
            var lineLeading = CGFloat()
            
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading)
            let runs = CTLineGetGlyphRuns(line) as! Array<CTRun>
            let lineOrigin = lineOrigins[i]
            originY = bounds.height - CGFloat(i) * lineHeight - lineAscent
            context.textPosition = CGPoint(x: lineOrigin.x, y: originY)
            CTLineDraw(line, context)
            for run in runs {
                let width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0,0), nil, nil, nil))
                let location = CTRunGetStringRange(run).location
                let runRect = CGRect(x: lineOrigin.x + CTLineGetOffsetForStringIndex(line,location, nil), y: CGFloat(i) * lineHeight, width: width, height: lineHeight)
                rects[YQRect(value: runRect)] = location
            }
        }
        self.rects = rects
    }

    
    override public var intrinsicContentSize: CGSize {
        guard  let text = drawText else {
            return CGSize.zero
        }
        return text.size(constraint: bounds.width, font: font, lineSpace: lineSpace)
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        guard  let text = drawText else {
            return CGSize.zero
        }
        return text.size(constraint: size.width, font: font, lineSpace: lineSpace)
    }
}

//MARK: -Touches
extension YQLabel {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchedDate = Date()
        isTouching = true
        let point = touch.location(in: self)
        for item in rects {
            if item.key.value.contains(point) {
                let touchLocation = item.value
                for paragraph in texts {
                    if paragraph.clickHandler != nil && paragraph.range().contains(touchLocation) {
                        touchedParagraph = paragraph
                        setNeedsDisplay()
                        break
                    }
                }
                break
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            touchOver()
        }
        if Date().timeIntervalSince(touchedDate) < 2 {
            guard let paragraph = self.touchedParagraph, let handler = paragraph.clickHandler else {
                return
            }
            handler(paragraph.text, paragraph.tag)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchOver()
    }
    
    func touchOver() {
        isTouching = false
        touchedParagraph = nil
        setNeedsDisplay()
    }
}

extension NSAttributedString {
    func size(constraint width: CGFloat, font: UIFont, lineSpace: CGFloat = 0) -> CGSize{
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), CGPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)), transform: nil), nil)
        let count = CGFloat(CFArrayGetCount(CTFrameGetLines(frame)))
        let size = CGSize(width: width, height: ceil(count * (font.lineHeight + lineSpace) - lineSpace))
        return size
    }

}

