//
//  ViewController.swift
//  ContactBrowser
//
//  Created by Colin Tan on 6/6/16.
//  Copyright © 2016 Intrepid Pursuilts LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var peopleTableView: UITableView!
    
    private var inputSearchText: String?
    private var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        
        loadSamplePeople()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        inputSearchText = textField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonTableViewCell", forIndexPath: indexPath) as! PersonTableViewCell
        
        // fetch person for data source layout
        let person = people[indexPath.row]
        
        cell.nameLabel.text = person.name
        cell.numberLabel.text = person.number
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        people[indexPath.row].callNumber()
    }

    
    // MARK: Sample Data
    func loadSamplePeople() {
        let p1 = Person(name: "David Angle", number: "774-312-3300")
        let p2 = Person(name: "Jen Laponte", number: "242-597-1280")
        let p3 = Person(name: "Daniel Patronsky", number: "433-997-0926")
        let p4 = Person(name: "Steven Rogers", number: "991-567-8324")
        people += [p1, p2, p3, p4]
    }
}

