//
//  CamerasData.swift
//  MyHouse
//
//  Created by Матвей on 31.05.2022.
//

import Foundation
import RealmSwift

struct Cameras: Codable {
    let success: Bool
    let data: CameraDataClass
}

struct CameraDataClass: Codable {
    let room: [String]
    let cameras: [Camera]
}


class Camera: Object, Codable {
    @objc dynamic var name: String 
    @objc dynamic var snapshot: String
    @objc dynamic var room: String?
    @objc dynamic var id: Int
    @objc dynamic var favorites, rec: Bool
}
