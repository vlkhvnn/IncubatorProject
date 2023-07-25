//
//  MessageModekl.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 12.07.2023.
//

import Foundation

struct MessageStruct : Identifiable, Codable, Hashable {
    var id = UUID()
    var content : String
    var isUserMessage: Bool
    var timestamp : Date
    var isFavourite : Bool
}

struct City: Identifiable {
    var id = UUID()
    var name : String
}
