//
//  UserData.swift
//  MRT
//
//  Created by Ronald Sumichael Sunan on 21/07/23.
//

import Foundation

struct UserData: Codable {
    let name: String
    let email: String
    let balance: String
    
    init(name: String, email: String, balance: String) {
        self.name = name
        self.email = email
        self.balance = balance
    }
}
