//
//  CloudKitManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//
// PROJECT REUSABLE

import CloudKit
import SwiftUI
import Combine

protocol CKObject {
    init(record: CKRecord) // do u want init?
    var record: CKRecord { get }
}

@MainActor final class CloudKitManager {
    
    // MARK: - Singleton
    static let shared = CloudKitManager()
    
    private init() {}
    
    private let container = CKContainer.default()
    private let publicDB = CKContainer.default().publicCloudDatabase
    private let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - User Functions
    var isSignedIntoiCloud: Bool = false
    var userGivenName: String?
    var userProfile: SabeelProfile?
    
    func getiCloudStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        container.accountStatus { status, err in
            switch status {
                case .couldNotDetermine:
                    print(err?.localizedDescription ?? "iCloud Status couldNotDetermine")
                    completion(.failure(err!))
                case .available:
                    self.isSignedIntoiCloud = true
                    completion(.success(self.isSignedIntoiCloud))
                case .restricted:
                    print(err?.localizedDescription ?? "iCloud Status restricted")
                    completion(.failure(err!))
                case .noAccount:
                    print(err?.localizedDescription ?? "iCloud Status noAccount")
                    completion(.failure(err!))
                case .temporarilyUnavailable:
                    print(err?.localizedDescription ?? "iCloud Status temporarilyUnavailable")
                    completion(.failure(err!))
                @unknown default:
                    print(err?.localizedDescription ?? "iCloud Status unknown")
                    completion(.failure(err!))
            }
        }
    }
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    func getUserRecord() async throws { // called in background (on lauch, only need it if we need an account for some tasks)
        let recordID = try await container.userRecordID()
        let record = try await publicDB.record(for: recordID)
        self.userRecord = record
        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
}


// MARK: - CRUD Functions
extension CloudKitManager {
    // save/create/update and delete
    @discardableResult
    func batchSave(records : [CKRecord]) async throws -> Bool {
        let recordsToSave = records
        let (savedResults, _) = try await publicDB.modifyRecords(saving: recordsToSave, deleting: [])
        return !(savedResults.compactMap { _, result in try? result.get() }.isEmpty)
    }
    @discardableResult
    func save<T:CKObject>(_ objects : [T]) async throws -> Bool {
        let recordsToSave = objects.map { $0.record }
        let (savedResults, _) = try await publicDB.modifyRecords(saving: recordsToSave, deleting: [])
        return !(savedResults.compactMap { _, result in try? result.get() }.isEmpty)
    }
    @discardableResult
    func batchDel<T:CKObject>(_ objects : [T]) async throws -> Bool {
        let recordIds = objects.map { $0.record.recordID }
        let (_, deletedResultsID) = try await publicDB.modifyRecords(saving: [], deleting: recordIds)
        return !(deletedResultsID.compactMap { id, _ in id }.isEmpty)
    }
    // MARK: READ
    func get<T:CKObject>(object type: SabeelRecordType  , from recordID: CKRecord.ID) async throws -> [T] {
        let predicate: NSPredicate = .equalToRecordId(of: recordID)
        let query = CKQuery(recordType: type.rawValue , predicate: predicate)
        let (matchResults, _) = try await publicDB.records(matching: query, resultsLimit: 1)
        let record = matchResults.compactMap{ _, result in try? result.get() }
        return record.map(T.init) // remember to cast
    }
    func getAll<T:CKObject>(
        objects type: SabeelRecordType,
        predicate: NSPredicate = NSPredicate(value: true),
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultLimit: Int = CKQueryOperation.maximumResults
    ) async throws -> [T] {
        let query = CKQuery(recordType: type.rawValue , predicate: predicate)
        query.sortDescriptors = sortDescriptors
        let (matchResults, _) = try await publicDB.records(matching: query, resultsLimit: resultLimit)
        let record = matchResults.compactMap{ _, result in try? result.get() }
        return record.map(T.init) // remember to cast
    }
}
