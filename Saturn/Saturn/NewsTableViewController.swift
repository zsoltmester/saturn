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

	var fetchResults: [FetchResult]?
	var fetchErrors: [FetchError]?

	// MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = feed.name

		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension

		feed.fetch(request: nil) { (results: [FetchResult]?, errors: [FetchError]?) in

			self.fetchResults = results
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

		return fetchResults?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
			fatalError("Not a valid NewsTableViewCell while loading the cells at NewsTableViewController.")
		}

		return cell
	}

}
