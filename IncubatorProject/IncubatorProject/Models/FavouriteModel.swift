//
//  FavouriteModel.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 13.07.2023.
//

import Foundation

struct Favourite : Identifiable, Codable, Hashable {
    var id = UUID()
    var model : String
    var mark : String
    var city : String
}
