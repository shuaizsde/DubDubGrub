//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 9/23/23.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
