//
//  NewsTableViewCell.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 17..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

	// MARK: - Properties

	static let reuseIdentifier = "News Cell"

	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var newsTextLabel: UILabel!
}
