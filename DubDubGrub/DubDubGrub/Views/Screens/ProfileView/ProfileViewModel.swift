//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import CloudKit
import Foundation

enum ProfileContext {case create, update}

final class ProfileViewModel: ObservableObject {

    @Published var firstName    = ""
    @Published var lastName     = ""
    @Published var companyName  = ""
    @Published var bio          = ""
    @Published var avatar       = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var isCheckedIn  = false
    @Published var isLoading = false

    @Published var alertItem: AlertItem?

    var existingProfileRecord: CKRecord? {
        didSet { profileContext = .update}
    }

    var profileContext: ProfileContext = .create

    func isValidProfile() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !bio.isEmpty,
              !companyName.isEmpty,
              avatar != PlaceholderImage.avatar,
              bio.count <= 100 else {return false}

        return true
    }

    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let record):
                    if record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference != nil {
                        self.isCheckedIn = true
                    } else {
                        self.isCheckedIn = false
                    }
                case .failure:
                    break
                }
            }
        }
    }

    func createProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        // Create our CKRecord from profile view
        let profileRecord = createProfileRecord()
        // get UserRecordID from the Container
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        // Create reference on UserRecord to DDGProfile we created
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(let records):
                    for record in records where record.recordType == RecordType.profile {
                        existingProfileRecord = record
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    alertItem = AlertContext.createProfileSuccess
                case .failure:
                    alertItem = AlertContext.createProfileFailure
                }
            }
        }
    }

    func getProfile() {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else {
            return
        }
        let profileRecordID = profileReference.recordID
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(let record):
                    existingProfileRecord = record
                    let profile     = DDGProfile(record: record)
                    firstName       = profile.firstName
                    lastName        = profile.lastName
                    bio             = profile.bio
                    companyName     = profile.companyName
                    avatar          = profile.avatarImage
                case .failure:
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
    }

    func updateProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        guard let profileRecord = existingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        profileRecord[DDGProfile.kFirstName]    = firstName
        profileRecord[DDGProfile.kLastName]     = lastName
        profileRecord[DDGProfile.kCompanyName]  = companyName
        profileRecord[DDGProfile.kBio]          = bio
        profileRecord[DDGProfile.kAvatar]       = avatar.convertToCKAsset()

        CloudKitManager.shared.save(record: profileRecord) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success:
                    alertItem = AlertContext.updateProfileSuccess
                case .failure:
                    alertItem = AlertContext.updateProfileFailure
                }
            }
        }
    }

    func checkOut() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }

        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            switch result {
            case .success(let record):
                record[DDGProfile.kIsCheckedIn] = nil
                record[DDGProfile.kIsCheckedInNilCheck] = nil
                CloudKitManager.shared.save(record: record) { [self] result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success:
                            isCheckedIn = false
                        case .failure:
                            alertItem = AlertContext.unableToCheckInOrOut
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async { self.alertItem = AlertContext.unableToCheckInOrOut }
            }
        }
    }

    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName]    = firstName
        profileRecord[DDGProfile.kLastName]     = lastName
        profileRecord[DDGProfile.kCompanyName]  = companyName
        profileRecord[DDGProfile.kBio]          = bio
        profileRecord[DDGProfile.kAvatar]       = avatar.convertToCKAsset()

        return profileRecord
    }

    private func showLoadingView() { isLoading = true }

    private func hideLoadingView() { isLoading = false }
}
