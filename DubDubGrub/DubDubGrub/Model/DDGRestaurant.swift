//
//  DDGRestaurant.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 10/5/23.
//

import Foundation



struct DDGRestaurant: Codable {
	let rating: Double
	let price: String
	let phone: String
	let id: String
	let reviewCount: Int
	let name: String
	let imageUrl: String
}
