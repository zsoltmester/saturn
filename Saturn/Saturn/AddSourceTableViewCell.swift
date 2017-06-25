//
//  AddSourceTableViewCell.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 07..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class AddSourceTableViewCell: UITableViewCell, UITextFieldDelegate {

	// MARK: - Properties

	static let reuseIdentifier = "Add Source Cell"

	@IBOutlet weak var providerNameLabel: UILabel!
	@IBOutlet weak var providerDetailLabel: UILabel!
	@IBOutlet weak var queryTextField: UITextField! {

		didSet {
			queryTextField.delegate = self
		}
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		textField.resignFirstResponder()

		return true
	}
}
