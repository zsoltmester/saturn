//
//  FeedTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 08..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

	// MARK: - Properties

	var feed: NewsFeed!

	// MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = feed.name
    }

}
