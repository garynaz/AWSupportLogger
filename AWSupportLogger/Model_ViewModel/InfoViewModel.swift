//
//  InfoViewModel.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/26/21.
//

import SwiftUI
import Firebase

class InfoViewModel:ObservableObject {
    private var db = Firestore.firestore()
    @Published var userInfo = [User]()
    
    
    func fetchUserData(){
        db.collection("info").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents were found")
                return
            }
            
            self.userInfo = documents.map { (documentSnapshot) -> User in
                let data = documentSnapshot.data()

                let company = data["company"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let admin = data["admin"] as? Bool ?? false
                let photo = data["photo"] as? String ?? ""
            
                return User(company: company, name: name, admin: admin, photo: photo, tickets: nil)
            }
        }
    }
    
    
    
}
