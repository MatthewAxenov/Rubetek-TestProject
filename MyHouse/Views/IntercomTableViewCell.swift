//
//  IntercomTableViewCell.swift
//  MyHouse
//
//  Created by Матвей on 01.06.2022.
//

import UIKit

class IntercomTableViewCell: UITableViewCell {
    
    @IBOutlet var intercomImage: UIImageView!
    @IBOutlet weak var intercomLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
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
        self.intercomImage.layer.cornerRadius = 15
        self.intercomLabel.text = model.name
        self.onlineLabel.text = "В сети"
        self.lockImage.tintColor = .blue
        self.intercomImage.setImage(imageUrl: model.snapshot!)
    }

}
