//
//  ColorCollectionViewCell.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 05..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Pastel
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

	// MARK: - Properties

	static let reuseIdentifier = "Color Cell"

	@IBOutlet weak var colorPastelView: PastelView! {

		didSet {
			colorPastelView.layer.cornerRadius = 10.0
			colorPastelView.layer.masksToBounds = true

			colorPastelView.startPastelPoint = .top
			colorPastelView.endPastelPoint = .bottom

			colorPastelView.animationDuration = 2
		}
	}
}
