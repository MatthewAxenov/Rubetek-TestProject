//
//  UIImageView Extension.swift
//  MyHouse
//
//  Created by Матвей on 01.06.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageUrl: String) {
        self.kf.setImage(with: URL(string: imageUrl))
    }
}
