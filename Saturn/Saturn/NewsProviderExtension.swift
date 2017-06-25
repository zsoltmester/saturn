//
//  NewsProviderExtension.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 06. 24..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import Foundation

extension NewsProvider {

	// MARK: - Properties

	var queryExecutor: QueryExecutor {

		switch identifier {

		case NewsProviderIdentifier.twitter.rawValue:
			return TwitterQueryExecutor.shared

		default:
			fatalError("Couldn't find query executor for news provider: \(name ?? ""), \(identifier)")
		}
	}

}
