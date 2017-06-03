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
	
	@IBOutlet weak var colorsPastelView: PastelView! {

		didSet {
			colorsPastelView.layer.cornerRadius = 10.0
			colorsPastelView.layer.masksToBounds = true

			colorsPastelView.startPastelPoint = .top
			colorsPastelView.endPastelPoint = .bottom
			
			colorsPastelView.animationDuration = 2;
		}
	}

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var sourcesLabel: UILabel!

}
