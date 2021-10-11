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
    @Published var messagesArray: [Message] = [Message]()
    @Published var signedIn: Bool = false
//    @State var noMsgs = false

    
    var signedOutTapped = false //Fixes issue with fetching object and re-triggering fetch request after SignOut.
    var handle: AuthStateDidChangeListenerHandle?
    var ticketListener: ListenerRegistration?
    
    let authRef = Auth.auth()
    
    var authHandle : AuthStateDidChangeListenerHandle?
    var rootInfoCollection : CollectionReference!
    var rootTicketCollection: CollectionReference?
    var userIdRef = ""
    
    var photoImage: UIImage?
    var downloadImageTask: StorageReference?
    
    
    func fetchAllMessageData(){
        db.collection("Users").document("\(userIdRef)").collection("messages").order(by: "stamp", descending: false).addSnapshotListener { querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Unable to return all Messages Snapshot, error: \(error!.localizedDescription)")
//                self.noMsgs = true
                return
            }
//
//            if snapshot.isEmpty{
//                self.noMsgs = true
//            } else {
//                self.noMsgs = false
//            }

            snapshot.documentChanges.forEach { diff in

                if (diff.type == .added) {
                    self.allMessagesArray.removeAll()
                    for message in querySnapshot!.documents{
                        let msgData = message.data()
                        let lastMsg = msgData["lastMsg"] as! String
                        let stamp = msgData["stamp"] as! Timestamp
                        let ticketId = msgData["ticketId"] as! String
                        let userId = msgData["userId"] as! String

                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yy"
                        let date = formatter.string(from: stamp.dateValue())

                        formatter.dateFormat = "hh:mm a"
                        let time = formatter.string(from: stamp.dateValue())

                        self.allMessagesArray.append(Message(userId: userId, lastMsg: lastMsg, time: time, date: date, stamp: stamp.dateValue(), ticketId: ticketId))
                    }

                }
            }
        }
    }
    
    
    func fetchMessageData(){
        db.collection("Messages").document("\(userIdRef)").collection("Message").order(by: "stamp", descending: false).addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Unable to return Messages Snapshot, error: \(error!.localizedDescription)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    self.messagesArray.removeAll()
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
                        
                        self.messagesArray.append(Message(userId: userId, lastMsg: message, time: time, date: date, stamp: stamp.dateValue(), ticketId: ticketId))
                    }
                    
                }
            }
        }
    }
        
    
    func fetchUserData(completion: @escaping () -> Void){
        db.collection("Users").document("\(userIdRef)").getDocument { [weak self] document, error in
            // Check for error
            if error == nil {
                // Check that this document exists
                if document != nil && document!.exists {
                    
                    self?.userInfo = document.map { (documentSnapshot) -> User in
                        let data = documentSnapshot.data()
                        
                        let company = data?["company"] as? String ?? ""
                        let name = data?["name"] as? String ?? ""
                        let admin = data?["admin"] as? Bool ?? false
                        let photoRef = data?["photo"] as? String ?? ""
                        let uid = data?["uid"] as? String ?? ""
                        
                        self?.downloadImageTask = Storage.storage().reference(withPath: photoRef)
                        return User(uid: uid, company: company, name: name, admin: admin, photoRef: photoRef, photoImage: nil)
                    }
                    completion()
                }
            }
        }
    }
    
    
    func fetchAllTicketData(){
        ticketListener = self.rootTicketCollection?.order(by: "date", descending: false).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
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
        ticketListener = self.rootTicketCollection?.whereField("userId", isEqualTo: self.userInfo!.uid).order(by: "date", descending: false).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
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
        downloadImageTask?.getData(maxSize: 6 * 1024 * 1024, completion: { [weak self] data, error in
            if let error = error {
                print("Got an error fetching data: \(error.localizedDescription)")
                return
            } else {
                self?.photoImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    withAnimation {
                        
                        //Fixes issue with fetching object and re-triggering fetch request after SignOut.
                        guard self?.signedOutTapped != true else {
                            self?.signedOutTapped = false
                            return
                        }
                        
                        self?.signedIn = true
                    }
                }
            }
        })
    }
    
    func listen(){
        print("Listener is triggered")
        handle = authRef.addStateDidChangeListener({ [weak self] auth, user in
            if let user = auth.currentUser {
                self?.userIdRef = user.uid
                self?.rootInfoCollection = Firestore.firestore().collection("/Users/")
                self?.rootTicketCollection = Firestore.firestore().collection("/Ticket/")
                self?.fetchUserData{
                    if self?.userInfo?.admin == false{
                        self?.downloadImageData()
                    } else {
                        self?.fetchAllTicketData()
                        self?.downloadImageData()
                    }
                }
            } else {
                self?.signedIn = false
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
        self.signedOutTapped = true //Fixes issue with fetching object and re-triggering fetch request after SignOut.
        
        do {
            try authRef.signOut()
        } catch {
            print(error)
        }
    }
    
    func signUp(email: String, password: String, company: String, name: String, admin: Bool, photoRef: String){
        authRef.createUser(withEmail: email, password: password) { result, error in
            
            guard result != nil, error == nil else {
                return
            }
            
            //Success
            self.db.collection("Users").document("\(result!.user.uid)").setData([
                "company" : "\(company)",
                "name" : "\(name)",
                "admin" : admin,
                "photo" : "\(photoRef)",
                "uid": "\(result!.user.uid)"
            ]) { error in
                if error != nil {
                    print(error!)
                }
            }
            
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
    
}
