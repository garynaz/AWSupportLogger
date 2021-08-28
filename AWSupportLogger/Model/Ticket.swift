//
//  Ticket.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/25/21.
//

import SwiftUI
import Firebase

class Ticket: Identifiable {
    var uid: UUID = UUID()
    var date: String
    var inquiry: String
    var priority: String
    var status: String
    var type: String
    
    
    init(date: String, inquiry: String, priority: String, status: String, type: String) {
        self.date = date
        self.inquiry = inquiry
        self.priority = priority
        self.status = status
        self.type = type
    }
}
