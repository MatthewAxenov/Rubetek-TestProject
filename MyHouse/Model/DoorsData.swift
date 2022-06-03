//
//  DoorsData.swift
//  MyHouse
//
//  Created by Матвей on 31.05.2022.
//

import Foundation
import RealmSwift

struct Doors: Codable {
    let success: Bool
    let data: [DoorsData]
}

class DoorsData: Object, Codable {
    @objc dynamic var name: String
    @objc dynamic var room: String?
    @objc dynamic var id: Int
    @objc dynamic var favorites: Bool
    @objc dynamic var snapshot: String?
}
