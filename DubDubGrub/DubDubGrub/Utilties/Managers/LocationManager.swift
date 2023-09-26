//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/29/21.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
