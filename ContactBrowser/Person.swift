//
//  Person.swift
//  ContactBrowser
//
//  Created by Zhuoming Tan on 6/7/16.
//  Copyright © 2016 Intrepid Pursuilts LLC. All rights reserved.
//

import UIKit

struct Person {
    var name: String
    var number: String
    
    func callNumber() {
        if let url = NSURL(string: "tel://" + number) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}