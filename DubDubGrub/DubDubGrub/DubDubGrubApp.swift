//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 5/19/23.
//

import SwiftUI

@main
struct DubDubGrubApp: App {

    let locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
