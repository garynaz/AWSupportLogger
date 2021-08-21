//
//  SessionStore.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 7/31/21.
//

import SwiftUI
import FirebaseAuth

//struct User {
//    var uid: String
//    var email: String
//}


class AppViewModel: ObservableObject {
//    @Published var session: User?
//    @Published var isAnon: Bool = false
//    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return authRef.currentUser != nil
    }
    
//    func listen() {
//        handle = authRef.addStateDidChangeListener({ auth, user in
//            if let user = user {
//                self.isAnon = false
//                self.session = User(uid: user.uid, email: user.email!)
//            } else {
//                self.isAnon = true
//                self.session = nil
//            }
//        })
//    }
    
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
    
    func signUp(email: String, password: String){
        authRef.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
//    func signOut() -> Bool {
//        do {
//            try authRef.signOut()
//            self.session = nil
//            self.isAnon = true
//            return true
//        } catch {
//            return false
//        }
//    }
    
//    func unbind() {
//        if let handle = handle {
//            authRef.removeStateDidChangeListener(handle)
//        }
//    }
    
}
