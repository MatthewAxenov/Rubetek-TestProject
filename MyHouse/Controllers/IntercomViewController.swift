//
//  IntercomViewController.swift
//  MyHouse
//
//  Created by Матвей on 01.06.2022.
//

import UIKit

class IntercomViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var keyButtonView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var intercomImage: UIImageView!
    
    var intercom = [DoorsData]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    func setLayout() {
        eyeButton.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.blue, renderingMode: .alwaysOriginal), for: .normal)
        backButton.setImage(UIImage(systemName: "backward")?.withTintColor(.blue, renderingMode: .alwaysOriginal), for: .normal)
        keyImage.tintColor = .blue
        keyButtonView.layer.cornerRadius = 15
        intercomImage.setImage(imageUrl: (intercom.first?.snapshot)!)
        titleLabel.text = intercom.first?.name
    }
    
    @IBAction func hideImage(_ sender: Any) {
        if intercomImage.isHidden == true {
            intercomImage.isHidden = false
        } else {
            intercomImage.isHidden = true
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
    

    

}
