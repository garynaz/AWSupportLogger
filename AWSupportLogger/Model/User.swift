//
//  Info.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/25/21.
//

import SwiftUI
import Firebase

class User: Identifiable {
    var uid: UUID
    var company: String
    var name: String
    var admin: Bool
    var photo: String
//    var tickets: [Ticket]?
    
    
    init(uid: UUID, company: String, name: String, admin: Bool, photo: String) {
        self.uid = uid
        self.company = company
        self.name = name
        self.admin = admin
        self.photo = photo
//        if let tickets = tickets {
//            self.tickets = tickets
//        }
    }
    
}
