//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/25/23.
//

import Foundation
import CloudKit
final class LocationListViewModel: ObservableObject {

    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]

    func getProfilesDictionary() {
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure:
                    print("Error getting back dictionary")
                }
            }
        }
    }

}
