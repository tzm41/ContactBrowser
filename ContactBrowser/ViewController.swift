//
//  ViewController.swift
//  ContactBrowser
//
//  Created by Colin Tan on 6/6/16.
//  Copyright © 2016 Intrepid Pursuits LLC. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// MARK: - Properties
	@IBOutlet fileprivate weak var peopleTableView: UITableView!

	fileprivate var people = [Person]()
	fileprivate var peopleSearchResult = [Person]()

	private let searchController = UISearchController(searchResultsController: nil)

	private var isSearching: Bool {
		return searchController.isActive && searchController.searchBar.text != ""
	}

	private var sectionedContacts = [Character: [Person]]()

	private var sortedSectionedContactsKeys: [Character] {
		return Array(sectionedContacts.keys).sorted()
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
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadSystemPeople()
        buildSectionHeaderTable(for: people)
    }

	// MARK: - UITableViewDelegate
	func numberOfSections(in tableView: UITableView) -> Int {
		if isSearching {
			return 1
		} else {
			return sectionedContacts.keys.count
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSearching {
			return peopleSearchResult.count
		} else {
			return sectionedContacts[sortedSectionedContactsKeys[section]]!.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell

        if let person = person(at: indexPath) {
            cell.nameLabel.text = person.name
			cell.numberLabel.text = person.number
        }
		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if isSearching {
			return ""
		} else {
			return String(sortedSectionedContactsKeys[section])
		}
	}

	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return sortedSectionedContactsKeys.map { String($0) }
	}
    
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let person = person(at: indexPath) {
            person.callNumber()
        }

		tableView.deselectRow(at: indexPath, animated: true)
	}
    
    private func person(at indexPath: IndexPath) -> Person? {
        if isSearching {
            return peopleSearchResult[indexPath.row]
        } else {
            let key = sortedSectionedContactsKeys[indexPath.section]
            if let peopleInThisSection = sectionedContacts[key] {
                return peopleInThisSection[indexPath.row]
            } else {
                return nil
            }
        }
    }
    
	// MARK: - UITableViewDataSource
	private func loadSystemPeople() {
        people.removeAll()
		let store = CNContactStore()
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]

		var allContainers = [CNContainer]()
		do {
			allContainers = try store.containers(matching: nil)
		} catch {
			print("Error fetching contact containers")
		}

		var contacts = [CNContact]()

		for container in allContainers {
			let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

			do {
				let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
				contacts.append(contentsOf: containerResults)

			} catch {
				print("Error fecthing results for contact containers")
			}
		}

		for contact in contacts {
			for number in contact.phoneNumbers {
				people.append(Person(name: contact.givenName + " " + contact.familyName, number: number.value.stringValue))
			}
		}
		people.sort { $0.name < $1.name }
	}

	private func buildSectionHeaderTable(for peopleToBeSectioned: [Person]) {
        sectionedContacts.removeAll()
		// contacts list should have been sorted
		var letters = peopleToBeSectioned.map { (person: Person) -> Character in
			return person.name[person.name.startIndex]
		}

		letters = letters.reduce([]) { (list, name) -> [Character] in
			if !list.contains(name) {
				return list + [name]
			}
			return list
		}

		for person in peopleToBeSectioned {
			if sectionedContacts[person.name[person.name.startIndex]] == nil {
				sectionedContacts[person.name[person.name.startIndex]] = [Person]()
			}

			sectionedContacts[person.name[person.name.startIndex]]!.append(person)
		}
	}
}

// MARK: - UISearchController
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
    }
    
    private func filterContent(for searchText: String) {
        peopleSearchResult = people.filter { aPerson in
            return aPerson.name.lowercased().contains(searchText.lowercased()) || aPerson.number.contains(searchText)
        }
        
        peopleTableView.reloadData()
    }
}

