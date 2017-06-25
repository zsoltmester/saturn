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

	private var newsSources: [Int:  [NewsSource]] = [:]

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

		} else if let cell: SourceTableViewCell = cell as? SourceTableViewCell {

			guard let newsSource = newsSources[indexPath.section]?[indexPath.row] else {
				fatalError("Couldn't find news source at \(indexPath).")
			}

			cell.queryLabel.text = newsSource.title ?? newsSource.query
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
			insertSource(from: indexPath)

		case .delete:
			sections[indexPath.section].remove(at: indexPath.row)
			let removedNewsSource = newsSources[indexPath.section]!.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			self.navigationItem.prompt = "Removed \(removedNewsSource.query ?? "")'s \(removedNewsSource.provider?.name ?? "")"

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

	// MARK: - Private Functions

	private func insertSource(from indexPath: IndexPath) {

		guard let cell = tableView.cellForRow(at: indexPath) as? AddSourceTableViewCell else {
			fatalError("Couldn't cast cell to AddSourceTableViewCell at index path: \(indexPath)")
		}

		guard let query = cell.queryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else {
			if !cell.queryTextField.isFirstResponder {
				cell.queryTextField.becomeFirstResponder()
			}
			return
		}

		guard let newsProvider = newsProviders[indexPath.section] else {
			fatalError("Couldn't find news provider for section \(indexPath.section)")
		}

		if let newsSourcesForThisSection = self.newsSources[indexPath.section] {
			for newsSource in newsSourcesForThisSection where newsSource.query == query {
				self.navigationItem.prompt = "\(query)'s \(newsProvider.name ?? "") already added."
				return
			}
		}

		cell.queryTextField.resignFirstResponder()
		beginLoading()

		self.navigationItem.prompt = "Searching \(query) on \(newsProvider.name ?? "")…"

		NewsSource.create(provider: newsProvider, query: query, completionHandler: { (newsSource: NewsSource?, error: QueryError?) in

			if error != nil {
				self.navigationItem.prompt = "Couldn't find \(query)'s \(newsProvider.name ?? "")."

			} else {

				guard let newsSource = newsSource else {
					fatalError("No error and no source at NewsSource.create's completionHandler.")
				}

				self.sections[indexPath.section].insert(.source, at: indexPath.row)

				if self.newsSources[indexPath.section] == nil {
					self.newsSources[indexPath.section] = [newsSource]
				} else {
					self.newsSources[indexPath.section]!.append(newsSource)
				}

				self.tableView.insertRows(at: [indexPath], with: .automatic)

				cell.queryTextField.text = nil

				self.navigationItem.prompt = "Successfully added \(query)'s \(newsProvider.name ?? "")"
			}

			self.endLoading()
		})
	}

	private func beginLoading() {

		UIApplication.shared.beginIgnoringInteractionEvents()

		UIApplication.shared.isNetworkActivityIndicatorVisible = true

		navigationItem.leftBarButtonItem?.isEnabled = false
		navigationItem.rightBarButtonItem?.isEnabled = false
	}

	private func endLoading() {

		UIApplication.shared.endIgnoringInteractionEvents()

		UIApplication.shared.isNetworkActivityIndicatorVisible = false

		navigationItem.leftBarButtonItem?.isEnabled = true
		navigationItem.rightBarButtonItem?.isEnabled = true
	}
}
