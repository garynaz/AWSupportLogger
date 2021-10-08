//
//  Message.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 9/27/21.
//

import SwiftUI
import Firebase

class Message: Identifiable {
    var id: UUID = UUID()
    var userId: String
    var lastMsg: String
    var time: String
    var date: String
    var stamp: Date
    
    init(userId: String, lastMsg: String, time: String, date: String, stamp: Date) {
        self.userId = userId
        self.lastMsg = lastMsg
        self.time = time
        self.date = date
        self.stamp = stamp
    }
}
