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
        if let url = URL(string: "telprompt:" + number) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
