//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/26/21.
//

import MapKit
import CloudKit

final class LocationMapViewModel: ObservableObject {
    @Published var isShowingDetailView = false
    @Published var alertItem: AlertItem?
    @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
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
    func getCheckedInCounts() {
        CloudKitManager.shared.getCheckedInProfilesCount { result in
            DispatchQueue.main.async {
                switch result {

                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure:
                    break
                }
            }
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
}
