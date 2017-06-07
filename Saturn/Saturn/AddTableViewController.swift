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
		case Source
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
		case .Source:
			cellIdentifier = SourceTableViewCell.reuseIdentifier
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case .AddSource, .Source:
			return true
		default:
			return false
		}
	}

	override func tableView(_ editedTableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		switch editingStyle {

		case .insert:
			editedTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
			tableView(editedTableView, didSelectRowAt: indexPath)

		case .delete:
			sections[indexPath.section].remove(at: indexPath.row)
			editedTableView.deleteRows(at: [indexPath], with: .automatic)

		default:
			fatalError("Invalid editing style: \(editingStyle)")
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case .AddSource:
			return .insert
		case .Source:
			return .delete
		default:
			return .none
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let item = sections[indexPath.section][indexPath.row]

		guard item == .AddSource else {
			return
		}

		tableView.beginUpdates()
		tableView.deselectRow(at: indexPath, animated: true)
		sections[indexPath.section].insert(.Source, at: indexPath.row)
		tableView.insertRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
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
