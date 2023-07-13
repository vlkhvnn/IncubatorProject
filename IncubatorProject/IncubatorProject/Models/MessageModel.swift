//
//  MessageModekl.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 12.07.2023.
//

import Foundation

struct Message : Identifiable, Codable, Hashable {
    var id = UUID()
    var content : String
    var isUserMessage: Bool
    var timestamp : Date
}
