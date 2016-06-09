//
//  Person.swift
//  ContactBrowser
//
//  Created by Colin Tan on 6/7/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit

struct Person {
    var name: String
    var number: String
    
    func callNumber() {
        if let url = NSURL(string: "telprompt:" + number) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}