//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/23/23.
//

import CloudKit
import Foundation
final class LocationListViewModel: ObservableObject {

    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
    @Published var alertItem: AlertItem?

    func getCheckedInProfilesDictionary() {
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure:
                    alertItem = AlertContext.unableToGetAllCheckedInProfiles
                }
            }
        }
    }

//    @ViewBuilder func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View {
//        if sizeCategory >= .accessibilityMedium {
//            LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
//        } else {
//            LocationDetailView(viewModel: LocationDetailViewModel(location: location))
//        }
//    }

}
