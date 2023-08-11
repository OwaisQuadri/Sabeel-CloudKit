//
//  PersonalInfoView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI
import CloudKit

struct PersonalInfoView: View {
    @State private var alertItem: AlertItem?
    @State var name : String = ""
    @State var handle : String = ""
    @State var isSaved : Bool = true
    @State var isCreatingNewProfile: Bool = true
    let kIsCreatingNewProfile = "isCreatingNewProfile"
    
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: kIsCreatingNewProfile)
    }
    func startUpChecks() {
        CloudKitManager.shared.getiCloudStatus { status in
            switch status {
                case .success(_):
                    DispatchQueue.main.async {
                        self.alertItem = AlertItem("iCloud logged in!", "Successfully logged in with iCloud.", "OK")
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.alertItem = AlertItem("iCloud Status Issue", "Please visit settings and ensure you are logged in with iCloud", "OK")
                    }
            }
        }
        
        CloudKitManager.shared.getUserRecord()
        
        // autofill if user is logged in
        name = ""
        handle = CloudKitManager.shared.userProfile?.username ?? ""
    }
    
    func saveProfile() {
        guard isValidProfile() else {
            // show alert
            alertItem = AlertContext.invalidProfile
            return
        }
    }
    
    func isValidProfile() -> Bool {
        guard
            !name.isEmpty,
            !handle.isEmpty ,
            handle.count < 20
                //          , handle.contains("[^A-Za-z0-9]")
        else { return false }
        return true
    }
    func createProfile() {
        guard isValidProfile() else {
            // show alert
            alertItem = AlertContext.invalidProfile
            return
        }
        // Create CKRecord from profile view
        let createdProfile = SabeelProfile(name: name, username: handle, homeAddress: nil, homeLocation: nil, isPremium: false, prayerStats: PrayerStats())
        guard let createdProfile = createdProfile else {
            self.alertItem = AlertItem("createdProfile", "unable to create profile" , "ok")
            return
        }
        let profileRecord = createdProfile.record
        
        CKContainer.default().fetchUserRecordID { recordId, err in
            guard let recordId = recordId, err == nil else {
                self.alertItem = AlertItem("recordId", err?.localizedDescription ?? "error" , "ok")
                return
            }
            // get userrecord from pub db
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { userRecord, err in
                guard let userRecord = userRecord, err == nil else {
                    self.alertItem = AlertItem("userRecord", err?.localizedDescription ?? "error" , "ok")
                    return
                }
                // create reference on UserRecord to the SabeelProfile we created
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                // honestly dont ever do .deleteself
                
                // create operation to save user and profile
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord,profileRecord])
                operation.modifyRecordsCompletionBlock = {recordsToSave, _, err in // _=deletedRecordIds
                    guard let savedRecords = recordsToSave, err == nil else {
                        self.alertItem = AlertItem("savedRecords", err?.localizedDescription ?? "error" , "ok")
                        return
                    }
                    // print the saved records
                    print(savedRecords)
                    self.alertItem = AlertItem("Success", "\(savedRecords)" , "sick!!")
                }
                // add operation to db
                CKContainer.default().publicCloudDatabase.add(operation) // its like task.resume() to fire off operation
                
            }
            
        }
        
        
        
        
        
        
        
        
        //create profile and send to CK
        guard let profile = SabeelProfile (name: name, username: handle, homeAddress: nil, homeLocation: nil, isPremium: false, prayerStats: PrayerStats()) else {
            self.alertItem = AlertItem("CKError", "some issue creating a profile object" , "bruh")
            return
        }
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertItem("CKError", "some issue getting user record" , "yikes")
            return
        }
        // if userRecord already has a userProfile Reference:
        let userProfileReference = CKRecord.Reference(record: CloudKitManager.shared.userProfile?.record ?? profile.record, action: .none)
        userRecord["userProfile"] = userProfileReference
        // check if this new username exists
        CloudKitManager.shared.read(recordType: .profile, predicate: NSPredicate(format: "username = %@", handle)) { (profiles: [SabeelProfile]) in
            if profiles.count > 0 {
                // if it does: alert
                DispatchQueue.main.async {
                    self.alertItem = AlertItem("This username already exists within our system", "Please select a new username", "Okay")
                }
            } else {
                // else: update record
                CloudKitManager.shared.userProfile = SabeelProfile(record: CKRecord(recordType: SabeelRecordType.profile.rawValue , recordID: userProfileReference.recordID))
                guard var userProfile = CloudKitManager.shared.userProfile else { return }
                userProfile.name = self.name
                userProfile.username = self.handle
                
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, userProfile.record])
                operation.modifyRecordsResultBlock = { res in
                    switch res {
                        case .success():
                            // set iscreatingprofile to false
                            self.isCreatingNewProfile = false
                            UserDefaults.standard.set(false, forKey: kIsCreatingNewProfile)
                        case .failure(let err):
                            self.alertItem = AlertItem("Error", err.localizedDescription, "Dismiss")
                    }
                }
                CloudKitManager.shared.add(operation: operation)
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading){
            Text("Personal Info:")
                .font(.caption)
                .foregroundColor(.brandSecondary)
            HStack {
                TextField("Name", text: $name)
                    .minimumScaleFactor(0.75)
                
                TextField("Username", text: $handle)
                    .minimumScaleFactor(0.75)
                    .bold()
                    .foregroundColor(.brandPrimary)
                    .frame(width: .relativeToScreen(.width, ratio: 0.3))
                Button {
                    isCreatingNewProfile ? createProfile() : saveProfile()
                } label: {
                    HStack{
                        Text(isCreatingNewProfile ? "Create" : "Save" )
                    }
                }
            }
            .textFieldStyle(.roundedBorder)
            
        }
        .onAppear {
            startUpChecks()
        }
        .toolbar {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .tint(.brandPrimary)
            }
            
        }
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    
    func getProfile() {
        // need user id to
        
        // get user record to
        
        // get user profile
    }

}


struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PersonalInfoView()
        }
    }
}

