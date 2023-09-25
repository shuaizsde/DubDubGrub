//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/26/21.
//

import MapKit

final class LocationMapViewModel: NSObject, ObservableObject {
    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?
    @Published var region = MKCoordinateRegion(
        center:
            CLLocationCoordinate2D(
                latitude: 37.331516,
                longitude: -121.891054
            ),
        span:
            MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
    )
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

    func getLocations(for locationManager: LocationManager) {
        CloudKitManager.shared.getLocations { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                case .failure:
                self.alertItem = AlertContext.unableToGetLocations
                }
            }
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

extension LocationMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
