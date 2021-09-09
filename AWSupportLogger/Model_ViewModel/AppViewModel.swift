//
//  SessionStore.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 7/31/21.
//

import SwiftUI
import Firebase
import FirebaseAuth



class AppViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var userInfo: User?
    @Published var signedIn: Bool = false
    
    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    var authHandle : AuthStateDidChangeListenerHandle?
    var rootInfoCollection : CollectionReference!
    var userIdRef = ""

    
    
    func fetchUserData(){
        db.collection("Users").document("\(userIdRef)").getDocument { document, error in
            // Check for error
            if error == nil {
                // Check that this document exists
                if document != nil && document!.exists {
                    
                    self.userInfo = document.map { (documentSnapshot) -> User in
                        let data = documentSnapshot.data()
                        
                        let uid = data?["uid"] as? UUID ?? UUID()
                        let company = data?["company"] as? String ?? ""
                        let name = data?["name"] as? String ?? ""
                        let admin = data?["admin"] as? Bool ?? false
                        let photo = data?["photo"] as? String ?? ""
                        
                        
                        return User(uid: uid, company: company, name: name, admin: admin, photo: photo)
                    }
                    
                    withAnimation {
                        self.signedIn = true
                    }
                    
                }
            }
        }
        
    }
    
    func listen(){
        handle = authRef.addStateDidChangeListener({ auth, user in
            if let user = auth.currentUser {
                self.userIdRef = user.uid
                self.rootInfoCollection = Firestore.firestore().collection("/Users/")
                
                DispatchQueue.main.async {
                    self.fetchUserData()
                }
                                
            } else {
                self.signedIn = false
            }
        })
        
    }
    
    func signIn(email: String, password: String){
        authRef.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                return
            }
        }
    }
    
    func signOut(){
        do {
            try authRef.signOut()
        } catch {
            print(error)
        }
    }
    
    func signUp(email: String, password: String, company: String, name: String, admin: Bool, photo: String){
        authRef.createUser(withEmail: email, password: password) { result, error in
            
            guard result != nil, error == nil else {
                return
            }
            
            let db = Firestore.firestore()
            
            //Success
            db.collection("Users").document("\(result!.user.uid)").setData(["company" : "\(company)", "name" : "\(name)", "admin" : admin, "photo" : "\(photo)", "uid":result!.user.uid]) { error in
                if error != nil {
                    print(error!)
                }
            }
            
        }
    }
    
    
    func unbind() {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
    
}
