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
    var photoRef: String
    var photoImage: UIImage?
//    var tickets: [Ticket]?
    
    
    init(uid: UUID, company: String, name: String, admin: Bool, photoRef: String, photoImage: UIImage?) {
        self.uid = uid
        self.company = company
        self.name = name
        self.admin = admin
        self.photoRef = photoRef
        self.photoImage = photoImage
//        if let tickets = tickets {
//            self.tickets = tickets
//        }
    }
    
}
