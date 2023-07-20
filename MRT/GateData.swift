//
//  GateData.swift
//  MRT
//
//  Created by Ronald Sumichael Sunan on 20/07/23.
//

import Foundation

struct GateData: Codable {
    let station: String
    let gate: Int
    
    init(station: String, gate: Int) {
        self.station = station
        self.gate = gate
    }
}
