//
//  FeedEditorTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 04..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

fileprivate enum SectionItem {

	case name
	case color
	case addSource
	case source
}

class FeedEditorTableViewController: UITableViewController, UITextFieldDelegate {

	// MARK: - Properties

	private var sections: [[SectionItem]] = [ [.name], [.color] ]

	private var newsProviders: [Int: NewsProvider] = [:]

	private var newsSources: [Int:  [NewsSource]] = [:]

	var selectedColor = 0

	var enteredName: String?

	var isEditingName = false {

		didSet {
			updateDoneButtonState()
		}
	}

	var feedToEdit: NewsFeed?

	// MARK: - Initialization

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44

		self.setEditing(true, animated: false)

		let order = [NSSortDescriptor(key: #keyPath(NewsProvider.name), ascending: true)]
		let newsProvidersInOrder = AppDelegate.shared.modelController.getNewsProviders(ordered: order)
		for newsProvider in newsProvidersInOrder {
			newsProviders[sections.count] = newsProvider
			sections.append([.addSource])
		}

		loadFeedToEdit()

		updateDoneButtonState()
	}

	func loadFeedToEdit() {

		guard let feedToEdit = feedToEdit else {
			return
		}

		enteredName = feedToEdit.name

		selectedColor = Int(feedToEdit.colorIdentifier)

		guard let feedToEditNewsSources = feedToEdit.sources?.allObjects as? [NewsSource] else {
			fatalError("Editing a feed, but it doesn't have any NewsSource.")
		}

		for (sectionIndex, sectionItems) in sections.enumerated() where sectionItems.last == .addSource {

			guard let newsProvider = newsProviders[sectionIndex] else {
				fatalError("Couldn't find news provider for section \(sectionIndex)")
			}

			for source in feedToEditNewsSources where source.provider?.identifier == newsProvider.identifier {

				self.sections[sectionIndex].insert(.source, at: 0)

				if self.newsSources[sectionIndex] == nil {
					self.newsSources[sectionIndex] = [source]
				} else {
					self.newsSources[sectionIndex]!.append(source)
				}

			}
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

		} else if let cell: NameTableViewCell = cell as? NameTableViewCell {

			cell.nameTextField.text = enteredName
			cell.nameTextField.delegate = self
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
			_ = newsSources[indexPath.section]!.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			updateDoneButtonState()

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

	// MARK: - UITextFieldDelegate

	func textFieldDidBeginEditing(_ textField: UITextField) {

		isEditingName = true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		textField.resignFirstResponder()

		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {

		textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		enteredName = textField.text

		isEditingName = false
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		switch segue.identifier ?? "" {

		case "Show Color":

			guard let colorSelectorCollectionViewController = segue.destination as? ColorSelectorCollectionViewController else {
				fatalError("Unexpected destination: \(segue.destination)")
			}

			colorSelectorCollectionViewController.selectedColor = selectedColor

		default:

			break
		}
	}

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		super.shouldPerformSegue(withIdentifier: identifier, sender: sender)

		switch identifier {

		case "Done":

			guard let name: String = enteredName else {
				fatalError("The enteredName is nil but the user pressed the done button.")
			}

			if let feedToEdit = feedToEdit {

				do {
					_ = try AppDelegate.shared.modelController.updateNewsFeed(feedToEdit, name: enteredName, colorIdentifier: Int16(selectedColor), sources: Set(newsSources.values.joined()))
				} catch ModelError.nameExists {

					showNameExistsAlertViewController(name)

					return false

				} catch {
					fatalError("Unexpected error while editing a new feed: \(error)")
				}

			} else {

				do {
					_ = try AppDelegate.shared.modelController.insertNewsFeed(name: name, colorIdentifier: Int16(selectedColor), sources: Set(newsSources.values.joined()))
				} catch ModelError.nameExists {

					showNameExistsAlertViewController(name)

					return false

				} catch {
					fatalError("Unexpected error while inserting a new feed: \(error)")
				}

			}

			return true

		default:

			return true
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
				return
			}
		}

		cell.queryTextField.resignFirstResponder()
		beginLoading()

		newsProvider.fetch(request: query) { (_, error: FetchError?) in

			if error == nil {

				let source = AppDelegate.shared.modelController.getNewsSource(provider: newsProvider, query: query) ?? AppDelegate.shared.modelController.insertNewsSource(provider: newsProvider, query: query)

				self.sections[indexPath.section].insert(.source, at: indexPath.row)

				if self.newsSources[indexPath.section] == nil {
					self.newsSources[indexPath.section] = [source]
				} else {
					self.newsSources[indexPath.section]!.append(source)
				}

				self.tableView.insertRows(at: [indexPath], with: .automatic)

				cell.queryTextField.text = nil

			} else {

				let alertViewController: UIAlertController = UIAlertController(title: "Couldn't find \(query)'s \(newsProvider.name ?? "")", message: nil, preferredStyle: .alert)
				alertViewController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
				self.present(alertViewController, animated: true, completion: nil)

			}

			self.endLoading()
		}
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
		updateDoneButtonState()
	}

	private func updateDoneButtonState() {

		navigationItem.rightBarButtonItem?.isEnabled = !isEditingName && !(enteredName?.isEmpty ?? true) && !Array(newsSources.values.joined()).isEmpty
	}

	private func showNameExistsAlertViewController(_ name: String) {

		let alertViewController: UIAlertController = UIAlertController(title: "\(name) already exists", message: "Enter a new name.", preferredStyle: .alert)
		alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alertViewController, animated: true, completion: nil)
	}

}
