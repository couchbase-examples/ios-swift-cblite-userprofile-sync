//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import Foundation
import CouchbaseLiteSwift


// MARK : typealias
enum UserRecordDocumentKeys:String {
    case type
    case name
    case email
    case address
    case image="imageData"
    case university
    case extended
}


// MARK: UserPresenterProtocol
// To be implemented by presenter
protocol UserPresenterProtocol : PresenterProtocol {
    func fetchRecordForCurrentUser( handler:@escaping(_ record:UserRecord?, _ error:Error?)->Void)
    func setRecordForCurrentUser( _ record:UserRecord?, handler:@escaping(_ error:Error?)->Void)
}

// MARK: UserPresentingViewProtocol
// To be implemented by the presenting view
protocol UserPresentingViewProtocol:PresentingViewProtocol {
    func updateUIWithUserRecord(_ record:UserRecord?,error:Error?)
}

// MARK: UserPresenter
class UserPresenter:UserPresenterProtocol {
    fileprivate var dbMgr:DatabaseManager = DatabaseManager.shared
    lazy var userProfileDocId: String = {
        let userId = dbMgr.currentUserCredentials?.user
        return "user::\(userId ?? "")"
    }()
    weak var associatedView: UserPresentingViewProtocol?
}

extension UserPresenter {
    func fetchRecordForCurrentUser( handler:@escaping(_ records:UserRecord?, _ error:Error?)->Void) {
        
        guard let db = dbMgr.db else {
            fatalError("db is not initialized at this point!")
        }
        
        var profile = UserRecord.init()
        profile.email = self.dbMgr.currentUserCredentials?.user
        self.associatedView?.dataStartedLoading()
    
        // fetch document corresponding to the user Id
        if let doc = db.document(withID: self.userProfileDocId)  {
        
            profile.email  =  doc.string(forKey: UserRecordDocumentKeys.email.rawValue)
            profile.address = doc.string(forKey:UserRecordDocumentKeys.address.rawValue)
            profile.name =  doc.string(forKey: UserRecordDocumentKeys.name.rawValue)
            profile.university = doc.string(forKey: UserRecordDocumentKeys.university.rawValue)
            profile.imageData = doc.blob(forKey:UserRecordDocumentKeys.image.rawValue)?.content
            
        }
        self.associatedView?.dataFinishedLoading()
        self.associatedView?.updateUIWithUserRecord(profile, error: nil)
    }
    
    func setRecordForCurrentUser( _ record:UserRecord?, handler:@escaping(_ error:Error?)->Void) {
        guard let db = dbMgr.db else {
            fatalError("db is not initialized at this point!")
        }
        // This will create a new instance of MutableDocument or will
        // fetch existing one
        // Get mutable version
        let mutableDoc = MutableDocument.init(id: self.userProfileDocId)

        mutableDoc.setString(record?.type, forKey: UserRecordDocumentKeys.type.rawValue)
        
        if let email = record?.email {
            mutableDoc.setString(email, forKey: UserRecordDocumentKeys.email.rawValue)
        }
        
        if let address = record?.address {
            mutableDoc.setString(address, forKey: UserRecordDocumentKeys.address.rawValue)
        }
        
        if let name = record?.name {
            mutableDoc.setString(name, forKey: UserRecordDocumentKeys.name.rawValue)
        }
        
        if let university = record?.university {
            mutableDoc.setString(university, forKey: UserRecordDocumentKeys.university.rawValue)
        }
       
        if let imageData = record?.imageData {
            let blob = Blob.init(contentType: "image/jpeg", data: imageData)
            mutableDoc.setBlob(blob, forKey: UserRecordDocumentKeys.image.rawValue)
        } 
        
        do {
            // This will create a document if it does not exist and overrite it if it exists
            // Using default concurrency control policy of "writes always win"
            try db.saveDocument(mutableDoc)
            handler(nil)
        }
        catch {
            handler(error)
        }
    }
    
}
// MARK: PresenterProtocol
extension UserPresenter:PresenterProtocol {
    func attachPresentingView(_ view:PresentingViewProtocol) {
        self.associatedView = view as? UserPresentingViewProtocol
        
    }
    func detachPresentingView(_ view:PresentingViewProtocol) {
        self.associatedView = nil
    }
}
