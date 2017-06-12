//
//  NameTableViewCell.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 04..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell, UITextFieldDelegate {

	// MARK: - Properties

	static let reuseIdentifier = "Name Cell"

	@IBOutlet weak var nameTextField: UITextField! {

		didSet {
			nameTextField.delegate = self
		}
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		textField.resignFirstResponder()

		return true
	}
}
