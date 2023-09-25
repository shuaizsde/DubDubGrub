//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import MapKit
import SwiftUI
import CloudKit

enum CheckInStatus {case checkedIn, checkedOut}

final class LocationDetailViewModel: NSObject, ObservableObject {
    @Published var isLoading = false
    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var isShowingProfileModal = false
    @Published var alertItem: AlertItem?
    
    var isCheckedIn: Bool = false
    var location: DDGLocation
    
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())]
    
    init(location: DDGLocation) {
        self.location = location
    }
     
    // MARK: Actions for Buttons
    func getDirectionsToLocation() {
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        // MKMapItem.openMaps(with: <#T##[MKMapItem]#>)  pass an array with start and end point
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        
    }
    
    func callLocation() {
        // guard let url = URL(string: "tel://832-366-1190") else {return}
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
            
        }
        UIApplication.shared.open(url)
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let record):
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        self.isCheckedIn = reference.recordID == self.location.id
                    }else {
                        self.isCheckedIn = false
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func updateCheckInStatus(to checkedInStatus: CheckInStatus) {
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                switch checkedInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                }
                
                CloudKitManager.shared.save(record: record) { [self] result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                            case .success(let record):
                                let profile = DDGProfile(record: record)
                                switch checkedInStatus {
                                    case .checkedIn:
                                        checkedInProfiles.append(profile)
                                    case .checkedOut:
                                        checkedInProfiles.removeAll(where: {$0.id == profile.id})
                                }
                            isCheckedIn = checkedInStatus == .checkedIn
                                print("✅checked in/out successfully")
                            case .failure(_):
                                print("❌Error saving Record")
                        }
                    }
                }
            case .failure(_):
                print("❌Error Fetching record")
            
            }
        }
        //Create a reference to the location
        
        // Save the updated profile to CloudKit
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profiles):
                    self.checkedInProfiles = profiles
                case .failure(_):
                    print("error fetching checkedin profiles")
                }
                hideLoadingView()
            }
        }
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
