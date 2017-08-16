//
//  NewsTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 08..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

	// MARK: - Properties

	var feed: NewsFeed!
	var news: [News]?
	var fetchErrors: [FetchError]?

	// MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = feed.name

		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension

		feed.fetch(request: nil) { (results: [News]?, errors: [FetchError]?) in

			self.news = results
			self.fetchErrors = errors

			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {

		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return news?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
			fatalError("Not a valid NewsTableViewCell while loading the cells at NewsTableViewController.")
		}

		let aNews = news?[indexPath.row]

		cell.titleLabel.text = aNews?.title ?? aNews?.source?.query
		cell.titleLabel.isHidden = cell.titleLabel.text?.isEmpty ?? true

		cell.newsTextLabel.text = aNews?.text
		cell.newsTextLabel.isHidden = cell.newsTextLabel.text?.isEmpty ?? true

		if aNews?.timestamp != nil {
			let currentDate = Date()
			let dateFormatter = DateComponentsFormatter()
			dateFormatter.unitsStyle = .full
			dateFormatter.maximumUnitCount = 1
			cell.timeLabel.text = dateFormatter.string(from: aNews!.timestamp!, to: currentDate) // swiftlint:disable:this force_unwrapping
		}
		if cell.timeLabel.text?.isEmpty ?? true {
			cell.timeLabel.isHidden = true
		} else {
			cell.timeLabel.isHidden = false
			cell.timeLabel.text = String(format: NSLocalizedString("News:TimeFormat", comment: ""), cell.timeLabel.text!) // swiftlint:disable:this force_unwrapping
		}

		return cell
	}

}
