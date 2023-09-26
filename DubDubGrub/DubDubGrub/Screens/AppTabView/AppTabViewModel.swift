//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/25/23.
//

import Foundation
import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject {

    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?

    var deviceLocationManager: CLLocationManager?

    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardView)
    }
    let kHasSeenOnboardView = "hasSeenOnboardView"

    // MARK: OnAppear Checks
    func runStartupChecks() {
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
        } else {
            checkIfLocationServicesIsEnabled()
        }
    }

    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            deviceLocationManager = CLLocationManager()
            deviceLocationManager!.delegate = self
        } else {
            alertItem = AlertContext.locationDisabled
        }
    }

    // HELPER:  CLLocationManagerDelegate completionHandler
    private func checkLocationAuthorization() {

        guard let deviceLocationManager = deviceLocationManager else { return }

        switch deviceLocationManager.authorizationStatus {
        case .notDetermined:
            deviceLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertItem = AlertContext.locationRestricted
        case .denied:
            alertItem = AlertContext.locationDenied
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
}

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
