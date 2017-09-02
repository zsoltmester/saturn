//
//  FeedEditorTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 04..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import FacebookCore
import FacebookLogin
import UIKit

private enum SectionItem {

	case name
	case addSource
	case source
}

private enum TextFieldTag: Int {

	case nameTextField
	case queryTextField
}

class FeedEditorTableViewController: UITableViewController, UITextFieldDelegate {

	// MARK: - Properties

	private var sections: [[SectionItem]] = [ [.name] ]

	private var newsProviders: [Int: NewsProvider] = [:]

	private var newsSources: [Int: [NewsSource]] = [:]

	private var enteredName: String?

	private var isEditingName = false {

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
		let newsProvidersInOrder = ModelController.shared.getNewsProviders(ordered: order)
		for newsProvider in newsProvidersInOrder {
			newsProviders[sections.count] = newsProvider
			sections.append([.addSource])
		}

		loadFeedToEdit()

		updateDoneButtonState()
	}

	private func loadFeedToEdit() {

		guard let feedToEdit = feedToEdit else {
			return
		}

		enteredName = feedToEdit.name

		guard let feedToEditNewsSources = feedToEdit.sources?.allObjects as? [NewsSource] else {
			fatalError("Editing a feed, but it doesn't have any sources.")
		}

		for (sectionIndex, sectionItems) in sections.enumerated() where sectionItems.last == .addSource {

			guard let newsProvider = newsProviders[sectionIndex] else {
				fatalError("Couldn't find news provider for section \(sectionIndex)")
			}

			for source in feedToEditNewsSources where source.provider?.identifier == newsProvider.identifier {

				self.sections[sectionIndex].insert(.source, at: 0)

				if var sourcesInSection = self.newsSources[sectionIndex] {
					sourcesInSection.append(source)
					self.newsSources[sectionIndex] = sourcesInSection
				} else {
					self.newsSources[sectionIndex] = [source]
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
			cell.queryTextField.tag = TextFieldTag.queryTextField.rawValue
			cell.queryTextField.delegate = self

		} else if let cell: SourceTableViewCell = cell as? SourceTableViewCell {

			guard let newsSource = newsSources[indexPath.section]?[indexPath.row] else {
				fatalError("Couldn't find news source at \(indexPath.debugDescription).")
			}

			cell.queryLabel.text = newsSource.name ?? newsSource.query

		} else if let cell: NameTableViewCell = cell as? NameTableViewCell {

			cell.nameTextField.text = enteredName
			cell.nameTextField.tag = TextFieldTag.nameTextField.rawValue
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
			guard var sourcesInSection = newsSources[indexPath.section] else {
				fatalError("No sources in section: \(indexPath.section)")
			}
			_ = sourcesInSection.remove(at: indexPath.row)
			newsSources[indexPath.section] = sourcesInSection
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

		if textField.tag == TextFieldTag.nameTextField.rawValue {

			isEditingName = true
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		textField.resignFirstResponder()

		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {

		if textField.tag == TextFieldTag.nameTextField.rawValue {

			textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
			enteredName = textField.text

			isEditingName = false
		}
	}

	// MARK: - Navigation

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		super.shouldPerformSegue(withIdentifier: identifier, sender: sender)

		switch identifier {

		case "Done":

			guard let name: String = enteredName else {
				fatalError("The enteredName is nil but the user pressed the done button.")
			}

			if let feedToEdit = feedToEdit {

				do {
					_ = try ModelController.shared.updateNewsFeed(feedToEdit, name: enteredName, sources: Set(newsSources.values.joined()))
				} catch ModelError.nameExists {

					showNameExistsAlertViewController(name)
					return false

				} catch {
					fatalError("Unexpected error while editing a news feed: \(error)")
				}

			} else {

				do {
					_ = try ModelController.shared.insertNewsFeed(name: name, sources: Set(newsSources.values.joined()))
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
			fatalError("Couldn't cast cell to AddSourceTableViewCell at index path: \(indexPath.debugDescription)")
		}

		guard let newsProvider = newsProviders[indexPath.section] else {
			fatalError("Couldn't find news provider for section \(indexPath.section)")
		}

		if newsProvider.identifier == NewsProviderIdentifier.facebook.rawValue && AccessToken.current == nil {

			Facebook.shared.login { result in

				DispatchQueue.main.async {
					switch result {

					case .cancelled, .failed:
						let alertViewController: UIAlertController = UIAlertController(title: NSLocalizedString("FeedEditor:Facebook:UnsuccessfulLoginAlert:Title", comment: ""), message: NSLocalizedString("FeedEditor:Facebook:UnsuccessfulLoginAlert:Message", comment: ""), preferredStyle: .alert)
						alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Alert:OkButton", comment: ""), style: .default, handler: nil))
						self.present(alertViewController, animated: true, completion: nil)

					case .success:
						self.insertSource(from: indexPath)
					}
				}
			}

			return
		}

		guard let query = cell.queryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else {
			cell.queryTextField.becomeFirstResponder()
			return
		}

		if let newsSourcesForThisSection = self.newsSources[indexPath.section] {
			for newsSource in newsSourcesForThisSection where newsSource.query == query {
				return
			}
		}

		cell.queryTextField.resignFirstResponder()
		beginLoading()

		newsProvider.fetch(with: query) { (_, errors: [FetchError]?) in

			DispatchQueue.main.async {
				if let errors = errors, !errors.isEmpty {

					self.handleFetchErrors(errors, provider: newsProvider, query: query)

				} else {

					let source = ModelController.shared.getNewsSource(provider: newsProvider, query: query) ?? ModelController.shared.insertNewsSource(provider: newsProvider, query: query)

					source.updateName()

					self.sections[indexPath.section].insert(.source, at: indexPath.row)

					if var sourcesInSection = self.newsSources[indexPath.section] {
						sourcesInSection.append(source)
						self.newsSources[indexPath.section] = sourcesInSection
					} else {
						self.newsSources[indexPath.section] = [source]
					}

					self.tableView.insertRows(at: [indexPath], with: .automatic)

					cell.queryTextField.text = nil
				}

				self.endLoading()
			}
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

		let alertViewController: UIAlertController = UIAlertController(title: String(format: NSLocalizedString("FeedEditor:NameExistsAlert:Title", comment: ""), name), message: NSLocalizedString("FeedEditor:NameExistsAlert:Message", comment: ""), preferredStyle: .alert)
		alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Alert:OkButton", comment: ""), style: .default, handler: nil))
		self.present(alertViewController, animated: true, completion: nil)
	}

	private func handleFetchErrors(_ errors: [FetchError], provider: NewsProvider, query: String) {

		if errors.contains(where: { error -> Bool in

			switch error {
			case .invalidQuery:
				return provider.identifier == NewsProviderIdentifier.rss.rawValue
			default:
				return false
			}

		}) {

			let alertViewController: UIAlertController = UIAlertController(title: NSLocalizedString("FeedEditor:RSS:InvalidUrlAlert:Title", comment: ""), message: nil, preferredStyle: .alert)
			alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Alert:OkButton", comment: ""), style: .default, handler: nil))
			self.present(alertViewController, animated: true, completion: nil)

		} else {

			let alertViewController: UIAlertController = UIAlertController(title: String(format: NSLocalizedString("FeedEditor:NotFoundAlert:Title", comment: ""), query, provider.name ?? ""), message: nil, preferredStyle: .alert)
			alertViewController.addAction(UIAlertAction(title: NSLocalizedString("Alert:OkButton", comment: ""), style: .default, handler: nil))
			self.present(alertViewController, animated: true, completion: nil)

		}

		for error in errors {
			print("Error while fetching \(provider.name ?? "") for \(query): \(error)")
		}
	}

}
