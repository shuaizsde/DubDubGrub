//
//  MockData.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/25/21.
//

import CloudKit

struct MockData {

    static var location: CKRecord {
        let record                          = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName]           = "Sean's Bar and Grill"
        record[DDGLocation.kAddress]        = "123 Main Street"
        record[DDGLocation.kDescription]    = "This is a test decription. Isn't it awesome. Not sure how long to make"
        record[DDGLocation.kWebsiteURL]     = "https://seanallen.co"
        record[DDGLocation.kLocation]       = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber]    = "111-111-1111"

        return record
    }
    static var profile: CKRecord {
        let record                          = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName]       = "Simon"
        record[DDGProfile.kLastName]        = "Zhang"
        record[DDGProfile.kCompanyName]     = "Meta?"
        record[DDGProfile.kBio]             = "When will I get the real job???"

        return record
    }
}
