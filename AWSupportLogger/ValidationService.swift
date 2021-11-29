//
//  ErrorType.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 11/25/21.
//

import Foundation
import SwiftUI

struct ValidationService{
    
}


enum LoginError: LocalizedError {
    case invalidValue
    case passwordTooLong
    case passwordTooShort
    case usernameTooLong
    case usernameTooShort
    
    var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "You have entered an invalid value."
        case .passwordTooLong:
            return "Your password is too long."
        case .passwordTooShort:
            return "Your password is too short."
        case .usernameTooLong:
            return "Your username is too long."
        case .usernameTooShort:
            return "Your username is too short."
        }
    }
}
