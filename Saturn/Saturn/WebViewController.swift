//
//  WebViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 08. 19..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

	// MARK: - Properties

	@IBOutlet weak var webView: UIWebView!

	var url: URL?

	// MARK: - Initialization

	override func viewDidLoad() {
        super.viewDidLoad()

		guard let url = url else {
			fatalError("No URL given for the WebViewController.")
		}

		webView.scrollView.bounces = false

		webView.loadRequest(URLRequest(url: url))
    }

}
