//
//  AddTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 04..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController {

	private enum SectionItem {
		case Name
		case Color
		case AddSource
	}

	// MARK: - Properties

	private var sections: [[SectionItem]] = [ [.Name, .Color], [.AddSource] ]

	var selectedColor = 0

	// MARK: - Initialization

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setEditing(true, animated: false)
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let item = sections[indexPath.section][indexPath.row]
		var cellIdentifier: String

		switch item {
		case .Name:
			cellIdentifier = NameTableViewCell.reuseIdentifier
		case .Color:
			cellIdentifier = ColorTableViewCell.reuseIdentifier
		case .AddSource:
			cellIdentifier = AddSourceTableViewCell.reuseIdentifier
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case .AddSource:
			return true
		default:
			return false
		}
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		// TODO handle the action
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case .AddSource:
			return .insert
		default:
			return .none
		}
	}

	override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return false
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		switch segue.identifier ?? "" {

		case "Show Color":
			guard let colorCollectionViewController = segue.destination as? ColorCollectionViewController else {
				fatalError("Unexpected destination: \(segue.destination)")
			}

			colorCollectionViewController.selectedColor = selectedColor

		default:
			fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")

		}
	}

	// MARK: - Actions

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

}
