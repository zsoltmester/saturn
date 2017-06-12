//
//  FeedTableViewCell.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Pastel
import UIKit

class FeedTableViewCell: UITableViewCell {

	// MARK: - Properties

	static let reuseIdentifier = "Feed Cell"

	@IBOutlet weak var colorPastelView: PastelView! {

		didSet {
			colorPastelView.layer.cornerRadius = 10.0
			colorPastelView.layer.masksToBounds = true

			colorPastelView.startPastelPoint = .top
			colorPastelView.endPastelPoint = .bottom

			colorPastelView.animationDuration = 2
		}
	}

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var sourcesLabel: UILabel!

}
