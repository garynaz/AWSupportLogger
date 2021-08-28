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
    @Published var signedIn: Bool = false
    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    
    func listen() {
        handle = authRef.addStateDidChangeListener({ auth, user in
            if user != nil {
                self.signedIn = true
            } else {
                self.signedIn = false
            }
        })
    }
    
    func signIn(email: String, password: String){
        authRef.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String, company: String, name: String, admin: Bool, photo: String){
        authRef.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            let db = Firestore.firestore()
            
            //Success
            DispatchQueue.main.async { [self] in
                db.collection("info").addDocument(data: ["company" : "\(company)", "name" : "\(name)", "admin" : admin, "photo" : "\(photo)"]) { error in
                    if error != nil {
                        print(error!)
                        self?.signedIn = false
                    } else {
                        self?.signedIn = true
                    }
                }
            }
        }
    }
    
    func signOut(){
        do {
            try authRef.signOut()
            self.signedIn = false
        } catch {
            print(error)
        }
    }
    
    func unbind() {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
    
}
