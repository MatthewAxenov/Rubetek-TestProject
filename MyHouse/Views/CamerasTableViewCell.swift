//
//  CamerasTableViewCell.swift
//  MyHouse
//
//  Created by Матвей on 31.05.2022.
//

import UIKit

class CamerasTableViewCell: UITableViewCell {
    
    @IBOutlet var cameraImage: UIImageView!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var recLabel: UILabel!
    
    @IBOutlet weak var view: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(with model: Camera) {
        self.view.layer.cornerRadius = 15
        self.cameraImage.layer.cornerRadius = 15
        self.cameraLabel.text = model.name
        self.cameraImage.setImage(imageUrl: model.snapshot)
        if model.favorites == true {
            starImage.isHidden = false
        } else {
            starImage.isHidden = true
        }
        if model.rec == true {
            recLabel.isHidden = false
        } else {
            recLabel.isHidden = true
        }
        
    }
    
    

}
