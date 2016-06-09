//
//  ViewController.swift
//  ContactBrowser
//
//  Created by Colin Tan on 6/6/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
	// MARK: - Properties
	@IBOutlet private weak var peopleTableView: UITableView!

	private var people = [Person]()
	private var peopleSearchResult = [Person]()

	private let searchController = UISearchController(searchResultsController: nil)

	private var isSearching: Bool {
		return searchController.active && searchController.searchBar.text != ""
	}

	private var sectionedContacts = [Character: [Person]]()

	private var sortedSectionedContactsKeys: [Character] {
		return Array(sectionedContacts.keys).sort()
	}

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true

		peopleTableView.delegate = self
		peopleTableView.dataSource = self
		peopleTableView.tableHeaderView = searchController.searchBar

		loadSystemPeople()
		buildSectionHeaderTable(people)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - UITableViewDelegate
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if isSearching {
			return 1
		} else {
			return sectionedContacts.keys.count
		}
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSearching {
			return peopleSearchResult.count
		} else {
			return sectionedContacts[sortedSectionedContactsKeys[section]]!.count
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PersonTableViewCell", forIndexPath: indexPath) as! PersonTableViewCell

		let person: Person
		if isSearching {
			person = peopleSearchResult[indexPath.row]

			cell.nameLabel.text = person.name
			cell.numberLabel.text = person.number
		} else {
			let key = sortedSectionedContactsKeys[indexPath.section]
			if let peopleInThisSection = sectionedContacts[key] {
				let person = peopleInThisSection[indexPath.row]
				cell.nameLabel.text = person.name
				cell.numberLabel.text = person.number

			}
		}
		return cell
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if isSearching {
			return ""
		} else {
			return String(sortedSectionedContactsKeys[section])
		}
	}

	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		return sortedSectionedContactsKeys.map { String($0) }
	}
    
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if isSearching {
			peopleSearchResult[indexPath.row].callNumber()
		} else {
            let key = sortedSectionedContactsKeys[indexPath.section]
            if let peopleInThisSection = sectionedContacts[key] {
                peopleInThisSection[indexPath.row].callNumber()
            }
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	// MARK: - UISearchController
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}

	private func filterContentForSearchText(searchText: String) {
		peopleSearchResult = people.filter { aPerson in
			return aPerson.name.lowercaseString.containsString(searchText.lowercaseString) || aPerson.number.containsString(searchText)
		}

		peopleTableView.reloadData()
	}

	// MARK: - Data Source
	private func loadSystemPeople() {
		let store = CNContactStore()
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]

		var allContainers = [CNContainer]()
		do {
			allContainers = try store.containersMatchingPredicate(nil)
		} catch {
			print("Error fetching contact containers")
		}

		var contacts = [CNContact]()

		for container in allContainers {
			let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)

			do {
				let containerResults = try store.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
				contacts.appendContentsOf(containerResults)

			} catch {
				print("Error fecthing results for contact containers")
			}
		}

		for contact in contacts {
			for number in contact.phoneNumbers {
				people.append(Person(name: contact.givenName + " " + contact.familyName, number: (number.value as! CNPhoneNumber).stringValue))
			}
		}
		people = people.sort { $0.name < $1.name }
	}

	private func buildSectionHeaderTable(peopleToBeSectioned: [Person]) {
		// contacts list should have been sorted
		var letters = peopleToBeSectioned.map { (person: Person) -> Character in
			return person.name[person.name.startIndex]
		}

		letters = letters.reduce([], combine: { (list, name) -> [Character] in
			if !list.contains(name) {
				return list + [name]
			}
			return list
		})

		for person in peopleToBeSectioned {
			if sectionedContacts[person.name[person.name.startIndex]] == nil {
				sectionedContacts[person.name[person.name.startIndex]] = [Person]()
			}

			sectionedContacts[person.name[person.name.startIndex]]!.append(person)
		}
	}
}

