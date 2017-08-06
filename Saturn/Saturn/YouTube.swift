//
//  YouTube.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 07. 20..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

//	Google API Manager: https://console.developers.google.com/apis/dashboard?project=saturn-174415
//	YouTube Data API docs: https://developers.google.com/youtube/v3/
//	Youtube Data API explorer: https://developers.google.com/apis-explorer/#p/youtube/v3/
//	Used services: https://developers.google.com/youtube/v3/docs/channels/list, playlistItems/list

import Foundation

class YouTube {

	// MARK: - Properties

	static let shared = YouTube()

	// MARK: - Initialization

	private init() {
	}

}

extension YouTube: Fetchable {

	// MARK: - Fetchable

	func fetch(request: FetchRequest?, completionHandler: @escaping FetchCompletionHandler) {

		guard let request = request else {
			fatalError("Fetching YouTube without a FetchRequest.")
		}

		fetchChannel(request) { (response: ChannelsResponse?, error: FetchError?) in

			guard error == nil else {
				completionHandler(nil, [error!]) // swiftlint:disable:this force_unwrapping
				return
			}

			guard let playlistId = response?.items.first?.contentDetails.relatedPlaylists.uploads else {
				completionHandler(nil, [FetchError.other(message: "No 'uploads' playlist available for a Youtube user: \(request)")])
				return
			}

			self.fetchPlaylistItems(playlistId) { (response: PlaylistItemsResponse?, error: FetchError?) in

				guard error == nil else {
					completionHandler(nil, [error!]) // swiftlint:disable:this force_unwrapping
					return
				}

				guard let playlistItems = response?.items else {
					completionHandler(nil, [FetchError.other(message: "No items on a YouTube playlist with ID: \(playlistId)")])
					return
				}

				var playlistItemsAsString = [String]()
				for playlistItem in playlistItems {
					playlistItemsAsString.append("\(playlistItem.snippet.title)\n\(playlistItem.snippet.description)")
				}

				completionHandler(playlistItemsAsString, nil)
			}
		}
	}

	// MARK: - Private Functions

	private func fetchChannel(_ channel: String, completionHandler: @escaping (ChannelsResponse?, FetchError?) -> Void) {

		let channelsServiceRequest = buildChannelsServiceRequest(channel)
		let channelsService = buildUrl(forPathTo: YouTubeApi.URL.Path.channels, with: channelsServiceRequest)

		URLSession.shared.dataTask(with: channelsService) { (data: Data?, _, error: Error?) in

			guard error == nil else {
				completionHandler(nil, FetchError.other(message: "Error in a YouTube channels service response: \(error!)")) // swiftlint:disable:this force_unwrapping
				return
			}

			guard let data = data else {
				completionHandler(nil, FetchError.other(message: "No error and data in a YouTube channels service response."))
				return
			}

			do {

				let response = try JSONDecoder().decode(ChannelsResponse.self, from: data)
				completionHandler(response, nil)

			} catch {
				completionHandler(nil, FetchError.other(message: "Couldn't convert YouTube channels service response to ChannelsResponse: \(String(data: data, encoding: .utf8) ?? "couldn't convert the data to string.")"))
			}

		}.resume()

	}

	private func fetchPlaylistItems(_ playlistId: String, completionHandler: @escaping (PlaylistItemsResponse?, FetchError?) -> Void) {

		let playlistItemsServiceRequest = self.buildPlaylistItemsServiceRequest(playlistId)
		let playlistItemsService = self.buildUrl(forPathTo: YouTubeApi.URL.Path.playlistItems, with: playlistItemsServiceRequest)

		URLSession.shared.dataTask(with: playlistItemsService) { (data: Data?, _, error: Error?) in

			guard error == nil else {
				completionHandler(nil, FetchError.other(message: "Error in a YouTube playlist items service response: \(error!)")) // swiftlint:disable:this force_unwrapping
				return
			}

			guard let data = data else {
				completionHandler(nil, FetchError.other(message: "No error and data when in a YouTube playlist items service response."))
				return
			}

			do {

				let response = try JSONDecoder().decode(PlaylistItemsResponse.self, from: data)
				completionHandler(response, nil)

			} catch {
				completionHandler(nil, FetchError.other(message: "Couldn't convert YouTube playlist items service response to PlaylistItemsResponse.self: \(String(data: data, encoding: .utf8) ?? "couldn't convert the data to string.")"))
			}

		}.resume()
	}

	private func buildUrl(forPathTo service: String, with parameters: [URLQueryItem]?) -> URL {

		var urlComponents = URLComponents()
		urlComponents.scheme = YouTubeApi.URL.scheme
		urlComponents.host = YouTubeApi.URL.host
		urlComponents.path = service
		urlComponents.queryItems = parameters

		guard let url = urlComponents.url else {
			fatalError("Couldn't convert to URL the URLComponents: \(urlComponents.debugDescription)")
		}

		return url
	}

	private func buildChannelsServiceRequest(_ channel: String) -> [URLQueryItem] {

		var request = [URLQueryItem]()
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.apiKey, value: YouTubeApi.key))
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.part, value: YouTubeApi.URL.Parameter.Value.contentDetails))
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.maxResults, value: "1"))
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.forUsername, value: channel))
		return request
	}

	private func buildPlaylistItemsServiceRequest(_ playlistId: String) -> [URLQueryItem] {

		var request = [URLQueryItem]()
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.apiKey, value: YouTubeApi.key))
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.part, value: YouTubeApi.URL.Parameter.Value.snippet))
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.maxResults, value: String(FetchConstants.maxResults)))
		request.append(URLQueryItem(name: YouTubeApi.URL.Parameter.playlistId, value: playlistId))
		return request
	}

}

private struct YouTubeApi {

	static let key = "AIzaSyBf1yQf80c3x-SHcx3VzSOdSuiPKTTtGDU"

	struct URL {

		static let scheme = "https"
		static let host = "www.googleapis.com"

		struct Path {

			private static let base = "/youtube/v3/"
			static let channels = base + "channels"
			static let playlistItems = base + "playlistItems"

		}

		struct Parameter {

			static let apiKey = "key"
			static let part = "part"
			static let forUsername = "forUsername"
			static let maxResults = "maxResults"
			static let playlistId = "playlistId"

			struct Value {

				static let contentDetails = "contentDetails"
				static let snippet = "snippet"

			}

		}

	}

}

private struct ChannelsResponse: Codable {

	struct Item: Codable {

		let contentDetails: ContentDetails

		struct ContentDetails: Codable {

			let relatedPlaylists: RelatedPlaylists

			struct RelatedPlaylists: Codable {

				let uploads: String

			}

		}

	}

	let items: [Item]
}

private struct PlaylistItemsResponse: Codable {

	struct Item: Codable {

		let snippet: Snippet

		struct Snippet: Codable {

			let title: String
			let description: String

		}

	}

	let items: [Item]
}
