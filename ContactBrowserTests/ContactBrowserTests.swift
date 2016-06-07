//
//  ContactBrowserTests.swift
//  ContactBrowser
//
//  Created by Zhuoming Tan on 6/7/16.
//  Copyright © 2016 Intrepid Pursuilts LLC. All rights reserved.
//

import XCTest

class ContactBrowserTests: XCTestCase {
    // MARK: Person Tests
    func testPersonInit() {
        let person1 = Person(name: "David Angel", number: "7743123333")
        XCTAssertNotNil(person1)
        print("Name: " + person1.name)
        print("Number: " + person1.number)
    }
}