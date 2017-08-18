//
//  NewsTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 08..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import SDWebImage
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

		let news = self.news?[indexPath.row]

		setupTitle(for: cell, with: news)
		setupText(for: cell, with: news)
		setupTime(for: cell, with: news)
		setupAvatar(for: cell, with: news)

		return cell
	}

	// MARK: - Cell Setup

	private func setupTitle(for cell: NewsTableViewCell, with news: News?) {

		cell.titleLabel.text = news?.title ?? news?.source?.query
		cell.titleLabel.isHidden = cell.titleLabel.text?.isEmpty ?? true
	}

	private func setupText(for cell: NewsTableViewCell, with news: News?) {

		cell.textView.text = news?.text
		cell.textView.isHidden = cell.textView.text?.isEmpty ?? true
	}

	private func setupTime(for cell: NewsTableViewCell, with news: News?) {

		if let timestamp = news?.timestamp {
			let currentDate = Date()
			let dateFormatter = DateComponentsFormatter()
			dateFormatter.unitsStyle = .full
			dateFormatter.maximumUnitCount = 1
			cell.timeLabel.text = dateFormatter.string(from: timestamp, to: currentDate)
		}
		if let timeText = cell.timeLabel.text, !timeText.isEmpty {
			cell.timeLabel.isHidden = false
			cell.timeLabel.text = String(format: NSLocalizedString("News:TimeFormat", comment: ""), timeText)
		} else {
			cell.timeLabel.isHidden = true
		}
	}

	private func setupAvatar(for cell: NewsTableViewCell, with news: News?) {

		if let avatarUrl = news?.avatarUrl {

			cell.avatarImageView.sd_setImage(with: avatarUrl, placeholderImage: Twitter.shared.placeholderImage, options: .refreshCached) { _, error, _, url in
				if let error = error {
					print("Error while downloading image at URL: \(url?.absoluteString ?? "nil"): \(error.localizedDescription)")
					cell.avatarImageView.image = Twitter.shared.errorImage
				}
			}

		} else {

			cell.avatarImageView.image = Twitter.shared.errorImage
		}
	}

}
