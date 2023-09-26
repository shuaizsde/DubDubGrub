//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/25/23.
//
import CoreLocation
import SwiftUI

final class AppTabViewModel: NSObject, ObservableObject {

    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?
    @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
        didSet {
            isShowingOnboardView = hasSeenOnboardView
        }
    }
    var deviceLocationManager: CLLocationManager?

    // MARK: OnAppear Checks
    func runStartupChecks() {
        if !hasSeenOnboardView {
            hasSeenOnboardView = true
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
