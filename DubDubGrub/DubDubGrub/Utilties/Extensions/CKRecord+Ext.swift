//
//  CKRecord+Ext.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/26/21.
//

import CloudKit

extension CKRecord {
    func convertToDDGLocation() -> DDGLocation { DDGLocation(record: self) }
    func convertToDDGProfile() -> DDGProfile { DDGProfile(record: self) }
}
