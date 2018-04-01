//
//  YQLabelTests.swift
//  YQLabelTests
//
//  Created by 王叶庆 on 2017/11/26.
//  Copyright © 2017年 王叶庆. All rights reserved.
//

import XCTest
@testable import YQLabel

class YQLabelTests: XCTestCase {
    let label = YQLabel(frame: CGRect(x: 0, y: 0, width: 232, height: 128))
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testReduce() {
        let array = [0,1]
        let r = array.reduce(Int()) { (result, item) -> Int in
//            result += item
            return result
        }
        XCTAssertEqual(r, 0)
    }
    
    func testStringLength() {
        XCTAssertEqual("a".utf8.count, 1)
        XCTAssertEqual("我".utf8.count, 3)
        XCTAssertEqual("我们".utf8.count, 6)
        XCTAssertEqual("我".count, 1)
        XCTAssertEqual("我".utf16.count, 1)
    }
    
    func testHash() {
        XCTAssertNotEqual(CGFloat(0.3).hashValue, 0)
    }
    
    func testIncludedParagraphs() {
        
        self.label.add(text: "洪七公", color: UIColor.blue)
        self.label.add(text: "回复", color: UIColor.red)
        self.label.add(text: "欧阳康", color: UIColor.green,  clickHandler: {(text, tag) in
            print("点击了 \(text)")
        })
        self.label.add(text: "我有葵花宝典你想练吗", color: UIColor.red, clickHandler: {(text, tag) -> Void in
            print(text)
        })
        self.label.add(text: "九阴真经", color: UIColor.red, clickHandler: {(text, tag) -> Void in
            print(text)
        })
  
        self.label.flash()
        let array1 = self.label.incluedParagraphs(start: 0, in: CFRangeMake(0, 9))
        
        XCTAssertNotNil(array1)
        XCTAssertTrue(array1.count == 4)
        
        let array2 = self.label.incluedParagraphs(start: 0, in: CFRangeMake(0, 2))
        XCTAssertNotNil(array2)
        XCTAssertTrue(array2.count == 1)
        
        let array3 = self.label.incluedParagraphs(start: 0, in: CFRangeMake(0, 4))
        XCTAssertNotNil(array3)
        XCTAssertTrue(array3.count == 2)
        
    }
    
    
    func testFaceLength() {
        XCTAssertTrue("😂😂".count == 2, "表情符号的长度啊")
    }
}
