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
	}

	// MARK: - Properties

	private var sections: [[SectionItem]] = [ [.Name], [.Color] ]

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
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

		return cell
	}

	// MARK: - Actions

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

}
