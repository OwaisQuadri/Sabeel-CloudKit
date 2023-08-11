//
//  CloudKitManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//

import CloudKit
import SwiftUI
import Combine

protocol CKObject {
    init(record: CKRecord) // do u want init?
    var record: CKRecord { get }
}

final class CloudKitManager {
    
    // MARK: - Singleton
    static let shared = CloudKitManager()
    
    private init() {}
    
    private let container = CKContainer.default()
    private let publicDB = CKContainer.default().publicCloudDatabase
    private let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - User Functions
    var isSignedIntoiCloud: Bool = false
    var userRecord: CKRecord?
    var userGivenName: String?
    var profileRecordId: CKRecord.ID?
    var userProfile: SabeelProfile?
    
    func getiCloudStatus(completion: @escaping (Result<Bool,Error>) -> Void) {
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
    
    func requestApplicationPermission (completion: @escaping (Result<Bool,Error>) -> Void) {
        container.requestApplicationPermission([.userDiscoverability]) { status, err in
            if status == .granted {
                completion(.success(true))
            } else {
                completion(.failure(err!))
            }
        }
    }
    
    func getUserRecord () {
        container.fetchUserRecordID { recordId, err in// get recordId
            guard let recordId = recordId, err == nil else {
                print(err!.localizedDescription)
                return
            }
            self.publicDB.fetch(withRecordID: recordId) { userRecord, err in // get userRecord
                guard let userRecord = userRecord, err == nil else {
                    print(err!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
                    self.profileRecordId = profileReference.recordID
                }
            }
        }
    }
    
    func fetchUserRecordId(completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        container.fetchUserRecordID { userRecordId, err in
            if let id = userRecordId {
                completion(.success(id))
            } else {
                completion(.failure(err!))
            }
        }
    }
    
    func fetchUserProfile () {
        if let userProfileReference = userRecord?["userProfile"] as? CKRecord.Reference {
            read(recordType: .profile, predicate: NSPredicate(format: "recordID = %@", userProfileReference.recordID)) { (items: [SabeelProfile]) in
                if items.count == 1 {
                    let profile = items[0]
                    DispatchQueue.main.async {
                        CloudKitManager.shared.userProfile = profile
                    }
                }
            }
        }
    }
}



// MARK: - CRUD Functions
extension CloudKitManager {
    
    
    // MARK: CREATE
    func add(operation: CKDatabaseOperation) {
        self.publicDB.add(operation)
    }
    
    func create<T:CKObject>(_ item: T,completion: @escaping (Result<Bool,Error>) -> Void) {
        
        // get record
        let record = item.record
        
        // Save to cloudkit
        save(record, completion: completion)
    }
    
    func save(_ record: CKRecord, completion: @escaping (Result<Bool,Error>) -> Void) {
        publicDB.save(record) { returnedRecord, err in
            if let err = err { completion(.failure(err)) } else { completion(.success(true)) }
        }
    }
    // MARK: READ
    func read<T:CKObject>(
        recordType: SabeelRecordType,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil,
        completion: @escaping (_ items: [T]) -> Void // usage: { (masjids as [Masjid]) in
    ) -> Void {
        let operation = createOperation(
            recordType: recordType.rawValue,
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            resultsLimit: resultsLimit
        )
        
        // get items in query
        var returnedItems: [T] = []
        
        addRecordMatchedBlock(operation: operation) { item in
            returnedItems.append(item)
        }
        
        // Query completion
        addQueryResultBlock(operation: operation) { finished in
            completion(returnedItems)
        }
        
        add(operation: operation)
        
    }
    
    private func createOperation(
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil
    ) -> CKQueryOperation {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        let queryOperation = CKQueryOperation(query: query)
        if let limit = resultsLimit {
            queryOperation.resultsLimit = limit
        }
        return queryOperation
    }
    
    private func addRecordMatchedBlock<T:CKObject>(operation: CKQueryOperation, completion: @escaping (_ item: T) -> Void) {
        if #available(iOS 15, *) {
            operation.recordMatchedBlock = { recordId, result in
                switch result {
                    case .success(let record):
                        let item = T(record: record)// guard let if optional init
                        completion(item)
                    case .failure:
                        break
                }
            }
        }
    }
    
    private func addQueryResultBlock(operation: CKQueryOperation, completion: @escaping (_ finished: Bool) -> Void) {
        if #available(iOS 15, *) {
            operation.queryResultBlock = { result in
                completion(true)
            }
        }
    }
    
    // MARK: UPDATE
    func update<T:CKObject>(_ item: T,completion: @escaping (Result<Bool,Error>) -> Void) { create(item, completion: completion) }
    
    
    
    // MARK: DELETE
    func delete<T:CKObject>(_ item: T, completion: @escaping (Result<Bool,Error>) -> Void) {
        self.delete(item.record, completion: completion)
    }
    
    private func delete(_ record: CKRecord, completion: @escaping (Result<Bool,Error>) -> Void) {
        publicDB.delete(withRecordID: record.recordID) { returnedRecordId, err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(true))
            }
        }
    }
}