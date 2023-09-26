//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import CloudKit
import MapKit
import SwiftUI

enum CheckInStatus {case checkedIn, checkedOut}

final class LocationDetailViewModel: NSObject, ObservableObject {

    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var isLoading = false
    @Published var isCheckedIn = false
    @Published var isShowingProfileModal = false

    @Published var alertItem: AlertItem?

    var location: DDGLocation

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    init(location: DDGLocation) {
        self.location = location
    }

    // MARK: Actions for Buttons
    func getDirectionsToLocation() {
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)

        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        /** MKMapItem.openMaps(with: <#T##[MKMapItem]#>)  pass an array with start and end point **/
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }

    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        UIApplication.shared.open(url)
    }

    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == self.location.id
                    } else {
                        isCheckedIn = false
                    }
                case .failure:
                    alertItem = AlertContext.unableToGetCheckInStatus
                }
            }
        }
    }

    func updateCheckInStatus(to checkedInStatus: CheckInStatus) {
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
		showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                switch checkedInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[DDGProfile.kIsCheckedInNilCheck] = 1
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                }

                CloudKitManager.shared.save(record: record) { [self] result in
                    DispatchQueue.main.async { [self] in
						hideLoadingView()
                        switch result {
                        case .success(let record):
                            let profile = DDGProfile(record: record)
                            switch checkedInStatus {
                            case .checkedIn:
                                checkedInProfiles.append(profile)
                            case .checkedOut:
                                checkedInProfiles.removeAll(where: { $0.id == profile.id })
                            }
                            isCheckedIn = checkedInStatus == .checkedIn
                        case .failure:
                            alertItem = AlertContext.updateProfileFailure
                        }
                    }
                }
            case .failure:
				hideLoadingView()
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }

    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedInProfiles = profiles
                case .failure:
                    alertItem = AlertContext.unableToGetCheckedInProfiles
                }
                hideLoadingView()
            }
        }
    }

    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
