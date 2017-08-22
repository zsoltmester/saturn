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

	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!

	@IBOutlet weak var avatarImageView: UIImageView! {

		didSet {

			guard avatarImageView.bounds.size.width == avatarImageView.bounds.size.height else {
				fatalError("Avatar image view in a NewsTableViewCell has wrong size: \(avatarImageView.bounds.size)")
			}

			let circularShape = CAShapeLayer()
			let circularShapePath = UIBezierPath(arcCenter: avatarImageView.center, radius: avatarImageView.bounds.size.width / 2, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
			circularShape.path = circularShapePath.cgPath
			avatarImageView.layer.mask = circularShape
		}
	}

	@IBOutlet weak var textView: UITextView! {

		didSet {

			textView.textContainerInset = UIEdgeInsets.zero
			textView.textContainer.lineFragmentPadding = 0
		}
	}

}
