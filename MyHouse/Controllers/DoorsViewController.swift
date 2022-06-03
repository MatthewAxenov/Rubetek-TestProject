//
//  DoorsViewController.swift
//  MyHouse
//
//  Created by Матвей on 31.05.2022.
//

import UIKit
import Alamofire
import RealmSwift

class DoorsViewController: UIViewController {
    
    //MARK: Properties
    
    let doorRealm = try! Realm()
    
    var doors = [DoorsData]()
    var intercom = [DoorsData]()
    
    let pullToRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchDoors), for: .valueChanged)
        return refresh
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = pullToRefresh
                
        if doorRealm.objects(DoorsData.self).isEmpty {
            fetchDoors(sender: pullToRefresh)
        } else {
            renderRealm()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: Get data with AF, save
        
    @objc func fetchDoors(sender: UIRefreshControl) {
      AF.request("http://cars.cprogroup.ru/api/rubetek/doors")
        .validate()
        .responseDecodable(of: Doors.self) { (response) in
          guard let data = response.value else { return }
            self.updateData()
            
            let doors = self.doorRealm.objects(DoorsData.self)
            try! self.doorRealm.write {
                self.doorRealm.delete(doors)
            }
            
            for i in data.data {
                if i.snapshot == nil {
                    self.doors.append(i)
                    
                    try! self.doorRealm.write({
                        self.doorRealm.add(i)
                    })
                }
            }
            
            for i in data.data {
                if i.snapshot != nil {
                    self.intercom.append(i)
                    
                    try! self.doorRealm.write({
                        self.doorRealm.add(i)
                    })
                }
            }
            
            sender.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Render Realm
    
    func renderRealm() {
        let doors = doorRealm.objects(DoorsData.self)
        updateData()
        for door in doors {
            if door.snapshot == nil {
                self.doors.append(door)
            } else {
                self.intercom.append(door)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateData() {
        self.doors = []
        self.intercom = []
    }
    
    func changeFavorites(indexPath: IndexPath, indexPlus: Int) {
        let door = self.doorRealm.objects(DoorsData.self)[indexPath.row + indexPlus]
        try! self.doorRealm.write({
            door.favorites = !door.favorites
        })
        tableView.reloadData()
    }
    
    //MARK: Alert
    
    func alert(indexPlus: Int, indexPath: IndexPath) {
        let door = self.doorRealm.objects(DoorsData.self)[indexPath.row + indexPlus]
        let alert = UIAlertController(title: "Переименовать дверь", message: "Введите название", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default) { action in
            let text = alert.textFields?.first?.text
            try! self.doorRealm.write({
                door.name = text ?? door.name
            })
            self.tableView.reloadData()
        }
        alert.addTextField()
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Intercom" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let intercom = intercom[indexPath.row]
            let intercomVC = segue.destination as! IntercomViewController
            intercomVC.intercom = self.intercom
        }
    }
    
}


extension DoorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return doors.count
        } else {
            return intercom.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoorCell", for: indexPath) as! DoorsTableViewCell
            cell.configure(with: doors[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntercomCell", for: indexPath) as! IntercomTableViewCell
            cell.configure(with: intercom[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 350
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let favAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                
                if indexPath.section == 0 {
                    self.changeFavorites(indexPath: indexPath, indexPlus: 0)
                    completionHandler(true)
                }
                
                if indexPath.section == 1 {
                    self.changeFavorites(indexPath: indexPath, indexPlus: self.doors.count)
                    completionHandler(true)
                }
            }
            favAction.image = UIImage(systemName: "star.circle")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
            favAction.backgroundColor = UIColor(named: "AccentColor")
        
            let renameAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                
                if indexPath.section == 0 {
                    self.alert(indexPlus: 0, indexPath: indexPath)
                    completionHandler(true)
                }
                
                if indexPath.section == 1 {
                    self.alert(indexPlus: self.doors.count, indexPath: indexPath)
                    completionHandler(true)
                }
        }
            renameAction.image = UIImage(systemName: "pencil.circle")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
            renameAction.backgroundColor = UIColor(named: "AccentColor")
        
        
            let configuration = UISwipeActionsConfiguration(actions: [favAction, renameAction])
            return configuration
    }
    
    
}
