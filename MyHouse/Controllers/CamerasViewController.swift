//
//  ViewController.swift
//  MyHouse
//
//  Created by Матвей on 31.05.2022.
//

import UIKit
import Alamofire
import RealmSwift

class CamerasViewController: UIViewController {
    
    //MARK: Properties
    
    let cameraRealm = try! Realm()
    
    var cameras = [Camera]()
    var rooms = [String]()
    var firstRoomCameras = [Camera]()
    var secondRoomCameras = [Camera]()
    
    let pullToRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchCameras), for: .valueChanged)
        return refresh
    }()
    
    @IBOutlet weak var tableView: UITableView!
    

    //MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = pullToRefresh
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 18.0)!]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        if cameraRealm.objects(Camera.self).isEmpty {
            fetchCameras(sender: pullToRefresh)
        } else {
            renderRealm()
        }
    }
    
    //MARK: Get data with AF, save
    
    @objc func fetchCameras(sender: UIRefreshControl) {
      AF.request("https://cars.cprogroup.ru/api/rubetek/cameras")
        .validate()
        .responseDecodable(of: Cameras.self) { (response) in
          guard let data = response.value else { return }
            self.updateData()
            let cameras = self.cameraRealm.objects(Camera.self)
            try! self.cameraRealm.write {
                self.cameraRealm.delete(cameras)
            }
            for i in data.data.cameras {
                if i.room == "FIRST" {
                    self.firstRoomCameras.append(i)
                    try! self.cameraRealm.write({
                        self.cameraRealm.add(i)
                    })
                }
            }
            
            for i in data.data.cameras {
                if i.room != "FIRST" {
                    self.secondRoomCameras.append(i)
                    try! self.cameraRealm.write({
                        self.cameraRealm.add(i)
                    })
                }
            }
            
          self.rooms = data.data.room
          self.cameras = data.data.cameras
            sender.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Render, change in Realm
    
    func renderRealm() {
        let cameras = cameraRealm.objects(Camera.self)
        updateData()
        for camera in cameras {
            if camera.room == "FIRST" {
                self.firstRoomCameras.append(camera)
            } else {
                self.secondRoomCameras.append(camera)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateData() {
        self.rooms = []
        self.firstRoomCameras = []
        self.secondRoomCameras = []
        self.cameras = []
    }
    
    func changeFavorites(indexPath: IndexPath, indexPlus: Int) {
        let camera = self.cameraRealm.objects(Camera.self)[indexPath.row + indexPlus]
        try! self.cameraRealm.write({
            camera.favorites = !camera.favorites
        })
        tableView.reloadData()
    }
}


extension CamerasViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstRoomCameras.count
        }
        return secondRoomCameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CameraCell", for: indexPath) as! CamerasTableViewCell
            cell.configure(with: firstRoomCameras[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CameraCell", for: indexPath) as! CamerasTableViewCell
            cell.configure(with: secondRoomCameras[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "FIRST"
        } else {
            return "SECOND"
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                let favAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                
                    if indexPath.section == 0 {
                        self.changeFavorites(indexPath: indexPath, indexPlus: 0)
                        completionHandler(true)
                }
                    
                    if indexPath.section == 1 {
                        self.changeFavorites(indexPath: indexPath, indexPlus: self.firstRoomCameras.count)
                        completionHandler(true)
                }
                    
            }
            favAction.image = UIImage(systemName: "star.circle")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
            favAction.backgroundColor = UIColor(named: "AccentColor")
            let configuration = UISwipeActionsConfiguration(actions: [favAction])
            return configuration
    }

    
}

