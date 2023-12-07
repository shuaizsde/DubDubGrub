//
//  YelpManager.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 10/5/23.
//

import Foundation
class RestaurantManager {

	static let shared = RestaurantManager()
	
	private let APIKey = "Bearer h9hpUcFYGPHDdxTYWsc3Y7DHIVfAJeQel4cDo49V1VGF2ksRhha9NpA3lariYbVRFxov-pG_gvy78WxxUNLYqt0XoabMdCrFMYsR30aGcgRHVxZZ8DFgMZQWSuQeZXYx"

	func getRestaurant(name: String) async -> DDGRestaurant? {
		guard let url = URL(string: "https://api.yelp.com/v3/businesses/" + name) else { return nil}

		var request = URLRequest(url: url)
		// You would typically have your API key here
		request.addValue(APIKey, forHTTPHeaderField: "Authorization")

		do {
			let (data, _) = try await URLSession.shared.data(for: request)

			// Decode the data into your YelpResponse struct
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			let restaurant = try decoder.decode(DDGRestaurant.self, from: data)

			// Now, you can access the properties of response, for example:
			return restaurant

		} catch {
			print("Error fetching data: \(error)")
		}
		return nil
	}

//	func getRestaurant(name: String) async -> DDGRestaurant? {
//		guard let url = URL(string: "https://api.yelp.com/v3/businesses/" + name) else { return nil}
//
//		var request = URLRequest(url: url)
//		// You would typically have your API key here
//		request.addValue(APIKey, forHTTPHeaderField: "Authorization")
//
//		do {
//			let (data, _) = try await URLSession.shared.data(for: request)
//
//			// Decode the data into your YelpResponse struct
//			let decoder = JSONDecoder()
//			decoder.keyDecodingStrategy = .convertFromSnakeCase
//			let restaurant = try decoder.decode(DDGRestaurant.self, from: data)
//
//			// Now, you can access the properties of response, for example:
//			return restaurant
//
//		} catch {
//			print("Error fetching data: \(error)")
//		}
//		return nil
//	}
	
}

struct YelpResponse: Codable {
	let total: Int
	let businesses: [DDGRestaurant]
}
