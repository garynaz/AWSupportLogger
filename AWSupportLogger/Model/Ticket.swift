//
//  Ticket.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/25/21.
//

import SwiftUI
import Firebase

class Ticket: Identifiable {
    var id: UUID = UUID()
    var date: String
    var inquiry: String
    var priority: String
    var status: String
    var type: String
    var key: DocumentReference!
    
    
    init(date: String, inquiry: String, priority: String, status: String, type: String, key: DocumentReference) {
        self.date = date
        self.inquiry = inquiry
        self.priority = priority
        self.status = status
        self.type = type
        self.key = key
    }
}
