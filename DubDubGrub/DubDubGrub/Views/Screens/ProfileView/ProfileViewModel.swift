//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import Foundation
import CloudKit

enum ProfileContext {case create, update}

final class ProfileViewModel: ObservableObject {
    
    @Published var firstName    = ""
    @Published var lastName     = ""
    @Published var companyName  = ""
    @Published var bio          = ""
    @Published var avatar       = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var alertItem: AlertItem?
    
    @Published var isLoading = false
    
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
                    }
                    alertItem = AlertContext.createProfileSuccess
                    break
                case .failure(_):
                    alertItem = AlertContext.createProfileFailure
                    break
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
                    avatar          = profile.createAvatarImage()

                case .failure(_):
                    alertItem = AlertContext.unableToGetProfile
                    break
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
                case .success(_):
                    alertItem = AlertContext.updateProfileSuccess
                case .failure(_):
                    alertItem = AlertContext.updateProfileFailure
                }
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
