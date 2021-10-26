//
//  Ticket.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/25/21.
//

import SwiftUI
import Firebase

struct Ticket: Identifiable {
    var id: UUID = UUID()
    var date: String
    var inquiry: String
    var priority: String
    var status: String
    var type: String
    var userId: String
    var key: DocumentReference!
    var ticketId: String
    
    
    init(date: String, inquiry: String, priority: String, status: String, type: String, userId: String, key: DocumentReference, ticketId: String) {
        self.date = date
        self.inquiry = inquiry
        self.priority = priority
        self.status = status
        self.type = type
        self.userId = userId
        self.key = key
        self.ticketId = ticketId
    }
}
