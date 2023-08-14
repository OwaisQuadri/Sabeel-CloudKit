//
//  NSPredicate+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-11.
//
// PROJECT REUSABLE

import CloudKit
extension NSPredicate {
    static func equalToRecordId(of recordID: CKRecord.ID) -> NSPredicate {
        NSPredicate(format: "recordID = %@", recordID)
    }
}
