//
//  ColorCollectionViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 05..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Pastel
import UIKit

class ColorCollectionViewController: UICollectionViewController {

	// MARK: - Properties

	var selectedColor = 0

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else {
			fatalError("Invalid cell type. Expected ColorCollectionViewCell.")
		}

		cell.setSelected(isSelected: indexPath.row == selectedColor)

		if let colorGradient: PastelGradient = PastelGradient(rawValue: indexPath.row) {
			cell.colorPastelView.setPastelGradient(colorGradient)
		} else {
			fatalError("Invalid pastel gradient index: \(indexPath.row).")
		}

        return cell
    }

    // MARK: - UICollectionViewDelegate

	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

		guard let cell = cell as? ColorCollectionViewCell else {
			fatalError("Invalid cell type. Expected ColorCollectionViewCell.")
		}

		cell.colorPastelView.startAnimation()
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		if indexPath.row == selectedColor {
			return
		}

		let changedItems = [IndexPath(row: selectedColor, section: indexPath.section), indexPath]

		selectedColor = indexPath.row

		collectionView.reloadItems(at: changedItems)
	}

	// MARK: - Navigation

	override func willMove(toParentViewController parent: UIViewController?) {

		if parent == nil, let navigationController = self.navigationController, navigationController.viewControllers.count >= 2 {

			let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2]
			if let addTableViewController = previousViewController as? AddTableViewController {
				addTableViewController.selectedColor = selectedColor
			}
		}
	}

}
