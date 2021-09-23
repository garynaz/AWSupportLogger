//
//  Info.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/25/21.
//

import SwiftUI
import Firebase

class User: Identifiable {
    var uid: String
    var company: String
    var name: String
    var admin: Bool
    var photoRef: String
    var photoImage: UIImage?
    
    
    init(uid: String, company: String, name: String, admin: Bool, photoRef: String, photoImage: UIImage?) {
        self.uid = uid
        self.company = company
        self.name = name
        self.admin = admin
        self.photoRef = photoRef
        self.photoImage = photoImage
    }
    
}
