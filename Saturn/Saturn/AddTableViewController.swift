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

		case name
		case color
		case addSource
		case source
	}

	// MARK: - Properties

	private var sections: [[SectionItem]] = [ [.name], [.color] ]

	private var newsProviders: [Int: NewsProvider] = [:]

	var selectedColor = 0

	// MARK: - Initialization

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44

		self.setEditing(true, animated: false)

		let order = [NSSortDescriptor(key: #keyPath(NewsProvider.name), ascending: true)]
		let newsProvidersInOrder = AppDelegate.get().modelController.getNewsProviders(ordered: order)
		for newsProvider in newsProvidersInOrder {
			newsProviders[sections.count] = newsProvider
			sections.append([.addSource])
		}
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
		case .name:
			cellIdentifier = NameTableViewCell.reuseIdentifier
		case .color:
			cellIdentifier = ColorTableViewCell.reuseIdentifier
		case .addSource:
			cellIdentifier = AddSourceTableViewCell.reuseIdentifier
		case .source:
			cellIdentifier = SourceTableViewCell.reuseIdentifier
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

		if let cell: AddSourceTableViewCell = cell as? AddSourceTableViewCell {
			guard let newsProvider = newsProviders[indexPath.section] else {
				fatalError("Couldn't find news provider for section \(indexPath.section)")
			}
			cell.providerNameLabel.text = newsProvider.name
			cell.providerDetailLabel.text = newsProvider.detail
			cell.queryTextField.placeholder = newsProvider.hint
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case .addSource, .source:
			return true
		default:
			return false
		}
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		switch editingStyle {

		case .insert:
			// TODO: disable the actions

			guard let cell = tableView.cellForRow(at: indexPath) as? AddSourceTableViewCell else {
				fatalError("Couldn't cast cell to AddSourceTableViewCell at index path: \(indexPath)")
			}

			// TODO: check for empty input

			do {
				_ = try newsProviders[indexPath.section]?.executeQuery(cell.queryTextField.text ?? "")
				sections[indexPath.section].insert(.source, at: indexPath.row)
				tableView.insertRows(at: [indexPath], with: .automatic)
			} catch {
				// TODO: print the eror
			}

			// TODO: enable the actions

		case .delete:
			sections[indexPath.section].remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)

		default:
			fatalError("Invalid editing style: \(editingStyle)")
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case .addSource:
			return .insert
		case .source:
			return .delete
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
