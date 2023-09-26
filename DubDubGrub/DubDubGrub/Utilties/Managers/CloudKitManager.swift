//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 5/26/21.
//

import CloudKit

final class CloudKitManager {

    static let shared = CloudKitManager()
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?

    private init() {}

    // Get current iCloud user
    func getUserRecord() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }

            // Get UserRecord from public database
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
                    self.profileRecordID = profileReference.recordID
                }
            }
        }
    }

    // Get all locations
    func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]

        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }

            guard let records = records else { return }

            let locations = records.map { $0.convertToDDGLocation() }
            completed(.success(locations))
        }
    }

    // Fetch all users where user.isCheckedIn == given location id
    func getCheckedInProfiles(for locationID: CKRecord.ID, completed: @escaping (Result<[DDGProfile], Error>) -> Void) {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)

        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                completed(.failure(error!))
                return
            }

            let profiles = records.map { $0.convertToDDGProfile() }
            completed(.success(profiles))

        }
    }

    func getCheckedInProfilesDictionary(completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void) {
        var checkInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)

        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in
            let profile = DDGProfile(record: record)
            guard let locationReference = profile.isCheckedIn else {return}
            checkInProfiles[locationReference.recordID, default: []].append(profile)
        }

        operation.queryCompletionBlock = { _, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(checkInProfiles))
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func getCheckedInProfilesCount(completed: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void) {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]

        var checkedInProfiles: [CKRecord.ID: Int] = [:]

        operation.recordFetchedBlock = { record in
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {return}
            let count = checkedInProfiles[locationReference.recordID] ?? 0
            checkedInProfiles[locationReference.recordID] = count + 1

        }

        operation.queryCompletionBlock = { _, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(checkedInProfiles))
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // MARK: Fetch or save records
    // Save a bunch of records changes into database
    func batchSave(records: [CKRecord], completed: @escaping (Result<[CKRecord], Error>) -> Void) {
        // Create a CKOpearation to save User and Profile Records
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        operation.modifyRecordsCompletionBlock = {savedRecords, _, error in
            guard let savedRecords = savedRecords, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        // Run the operation
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    // Save one record changes into database
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }

    // Fetch any iCloud record by id
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) {record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }


}
