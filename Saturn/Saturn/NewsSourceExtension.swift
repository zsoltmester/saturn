//
//  NewsSourceExtension.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import UIKit

extension NewsSource {

	// MARK: - Public Functions

	static func create(provider: NewsProvider, query: String) throws -> NewsSource {

		_ = try provider.executeQuery(query)

		// TODO: how to get the title?

		return AppDelegate.get().modelController.insertNewsSource(provider: provider, query: query)
	}
}
