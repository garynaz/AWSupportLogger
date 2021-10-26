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
    @Published var userTicketsArray: [Ticket] = [Ticket]()
    @Published var allTicketsArray: [Ticket] = [Ticket]()
    @Published var allMessagesArray: [Message] = [Message]()
    @Published var signedIn: Bool = false
    @Published var alert = false
    @Published var error = ""
    
    var signedOutTapped = false //Fixes issue with fetching object and re-triggering fetch request after SignOut.
    var handle: AuthStateDidChangeListenerHandle?
    var ticketListener: ListenerRegistration?
    
    let authRef = Auth.auth()
    
    var authHandle : AuthStateDidChangeListenerHandle?
    var rootInfoCollection : CollectionReference!
    var rootTicketCollection: CollectionReference?
    var rootMessageCollection: CollectionReference?
    
    var userIdRef = ""
    
    var photoImage: UIImage?
    var downloadImageTask: StorageReference?
    
        
    func fetchAllMessageData(){
        db.collection("Messages").order(by: "stamp", descending: false).addSnapshotListener { querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Unable to return all Messages Data, error: \(error!.localizedDescription)")
                return
            }

            snapshot.documentChanges.forEach { diff in

                if (diff.type == .added) {
                    self.allMessagesArray.removeAll()
                    for message in querySnapshot!.documents{
                        let msgData = message.data()
                        let message = msgData["message"] as! String
                        let stamp = msgData["stamp"] as! Timestamp
                        let ticketId = msgData["ticketId"] as! String
                        let userId = msgData["userId"] as! String

                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yy"
                        let date = formatter.string(from: stamp.dateValue())

                        formatter.dateFormat = "hh:mm a"
                        let time = formatter.string(from: stamp.dateValue())

                        self.allMessagesArray.append(Message(userId: userId, lastMsg: message, time: time, date: date, stamp: stamp.dateValue(), ticketId: ticketId))
                    }

                }
            }
        }
    }
    
    
    func fetchUserData(completion: @escaping () -> Void){
        db.collection("Users").document("\(userIdRef)").getDocument { document, error in
            // Check for error
            if let error = error{
                print("Got an error fetching User Data: \(error.localizedDescription)")
                return
            } else {
                // Check that this document exists
                if document != nil && document!.exists {
                    
                    self.userInfo = document.map { (documentSnapshot) -> User in
                        let data = documentSnapshot.data()
                        
                        let company = data?["company"] as? String ?? ""
                        let name = data?["name"] as? String ?? ""
                        let admin = data?["admin"] as? Bool ?? false
                        let photoRef = data?["photo"] as? String ?? ""
                        let uid = data?["uid"] as? String ?? ""
                        
                        self.downloadImageTask = Storage.storage().reference(withPath: photoRef)
                        return User(uid: uid, company: company, name: name, admin: admin, photoRef: photoRef, photoImage: nil)
                    }
                    completion()
                }
            }
        }
    }
    
    
    func fetchAllTicketData(){
        ticketListener = self.rootTicketCollection?.order(by: "date", descending: false).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Unable to return All Tickets Data, error: \(error!.localizedDescription)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    self.allTicketsArray.removeAll()
                    
                    for ticket in querySnapshot!.documents{
                        let ticketData = ticket.data()
                        let date = ticketData["date"] as! String
                        let status = ticketData["status"] as! String
                        let type = ticketData["type"] as! String
                        let inquiry = ticketData["inquiry"] as! String
                        let priority = ticketData["priority"] as! String
                        let userId = ticketData["userId"] as! String
                        
                        let newTicket = Ticket(date: date, inquiry: inquiry, priority: priority, status: status, type: type, userId: userId, key: ticket.reference, ticketId: ticket.documentID)
                        self.allTicketsArray.append(newTicket)
                    }
                    
                }
            }
        })
    }
    
    
    func fetchTicketsData(){
        ticketListener = self.rootTicketCollection?.whereField("userId", isEqualTo: self.userInfo!.uid).order(by: "date", descending: true).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Unable to return Tickets Data, error: \(error!.localizedDescription)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    self.userTicketsArray.removeAll()
                    
                    for ticket in querySnapshot!.documents{
                        let ticketData = ticket.data()
                        let date = ticketData["date"] as! String
                        let status = ticketData["status"] as! String
                        let type = ticketData["type"] as! String
                        let inquiry = ticketData["inquiry"] as! String
                        let priority = ticketData["priority"] as! String
                        let userId = ticketData["userId"] as! String
                        
                        let newTicket = Ticket(date: date, inquiry: inquiry, priority: priority, status: status, type: type, userId: userId, key: ticket.reference, ticketId: ticket.documentID)
                        self.userTicketsArray.append(newTicket)
                    }
                    
                }
            }
        })
    }
    
    func downloadImageData(){
        downloadImageTask?.getData(maxSize: 6 * 1024 * 1024, completion: { data, error in
            if let error = error {
                print("Got an error Download Image data: \(error.localizedDescription)")
                return
            } else {
                self.photoImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    withAnimation {
                        
                        //Fixes issue with fetching object and re-triggering fetch request after SignOut.
                        guard self.signedOutTapped != true else {
                            self.signedOutTapped = false
                            return
                        }
                        
                        self.signedIn = true
                    }
                }
            }
        })
    }
    
    func listen(){
        print("Listener is triggered")
        handle = authRef.addStateDidChangeListener({ auth, user in
            if let user = auth.currentUser {
                self.userIdRef = user.uid
                self.rootInfoCollection = Firestore.firestore().collection("/Users/")
                self.rootTicketCollection = Firestore.firestore().collection("/Ticket/")
                self.rootMessageCollection = Firestore.firestore().collection("/Messages/")
                self.fetchUserData{
                     if self.userInfo?.admin == false{
                        self.fetchTicketsData()
                        self.fetchAllMessageData()
                        self.downloadImageData()
                    } else {
                        self.fetchAllTicketData()
                        self.fetchAllMessageData()
                        self.downloadImageData()
                    }
                }
            } else {
                self.signedIn = false
            }
        })
    }
    
    func signIn(email: String, password: String){
        
        if email != "" && password != ""{
            authRef.signIn(withEmail: email, password: password) { result, error in
                guard result != nil, error == nil else {
                    self.error = error!.localizedDescription
                    self.alert.toggle()
                    return
                }
            }
        } else {
            self.error = "Please fill all the contents properly."
            self.alert.toggle()
        }
        
    }
    
    func signOut(){
        self.signedOutTapped = true //Fixes issue with fetching object and re-triggering fetch request after SignOut.
        
        do {
            try authRef.signOut()
        } catch {
            print(error)
        }
    }
    
    func signUp(email: String, password: String, repassword: String, company: String, name: String, admin: Bool, imageURL: URL?){
        
        if email != "" || password != "" || repassword != "" || name != "" || company != ""{
            
            if password == repassword {
                
                let randomID = UUID.init().uuidString
                
                if imageURL != nil {
                    Storage.storage().reference().child("images/\(randomID).jpg").putFile(from: imageURL!, metadata: nil) { [self] metadata, error in
                        authRef.createUser(withEmail: email, password: password) { result, error in
                            
                            guard result != nil, error == nil else {
                                self.error = error!.localizedDescription
                                self.alert.toggle()
                                return
                            }
                            
                            //Success
                            self.db.collection("Users").document("\(result!.user.uid)").setData([
                                "company" : "\(company)",
                                "name" : "\(name)",
                                "admin" : admin,
                                "photo" : "images/\(randomID).jpg",
                                "uid": "\(result!.user.uid)"
                            ]) { error in
                                if error != nil {
                                    print(error!)
                                }
                            }
                            
                        }
                    }
                } else {
                    
                    let defaultUserImage = UIImage(systemName: "person.circle")?.pngData()
                    
                    Storage.storage().reference().child("images/\(randomID).jpg").putData((defaultUserImage)!, metadata: nil) { [self] metadata, error in
                        authRef.createUser(withEmail: email, password: password) { result, error in
                            
                            guard result != nil, error == nil else {
                                self.error = error!.localizedDescription
                                self.alert.toggle()
                                return
                            }
                            
                            //Success
                            self.db.collection("Users").document("\(result!.user.uid)").setData([
                                "company" : "\(company)",
                                "name" : "\(name)",
                                "admin" : admin,
                                "photo" : "images/\(randomID).jpg",
                                "uid": "\(result!.user.uid)"
                            ]) { error in
                                if error != nil {
                                    print(error!)
                                }
                            }
                            
                        }

                    }
                }
                
            } else {
                self.error = "Password Mismatch"
                self.alert.toggle()
            }
            
        } else {
            self.error = "Please fill all the contents properly."
            self.alert.toggle()
        }
        
        
    }
    
    
    func unbind() {
        
        if let ticketListener = ticketListener {
            ticketListener.remove()
        }
        
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
    
    
    func addTicket(inquiry: String, priority: String, status: String, type: String){
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        self.rootTicketCollection?.addDocument(data: [
            "date" : "\(formatter.string(from: today))",
            "inquiry" : inquiry,
            "priority" : "\(priority)",
            "status": "\(status)",
            "type": "\(type)",
            "userId": "\(self.userInfo!.uid)"
        ], completion: { error in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
    }
    
    func sendMsg(message: String, stamp: Timestamp, ticketId: String, userId: String){
                
        db.collection("Messages").addDocument(data: [
            "message" : message,
            "stamp" : stamp,
            "ticketId" : ticketId,
            "userId" : userId
        ]) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
    }
    
}
