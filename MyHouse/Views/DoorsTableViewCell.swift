//
//  DoorsTableViewCell.swift
//  MyHouse
//
//  Created by Матвей on 01.06.2022.
//

import UIKit

class DoorsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var doorLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: DoorsData) {
        self.view.layer.cornerRadius = 15
        self.doorLabel.text = model.name
        self.lockImage.tintColor = .blue
    }

}
