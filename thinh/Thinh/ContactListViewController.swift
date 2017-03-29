//
//  ContactListViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/26/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {

    @IBOutlet weak var contactListTable: UITableView!
    
    
    @IBAction func onClickThaThinhButton(_ sender: UIButton) {
        print("[xx]thathinh")
    }
    var contactList = [User]()
    let refreshController = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListTable.delegate = self
        contactListTable.dataSource = self
        
        loadContactList()
        contactListTable.reloadData()
        
        contactListTable.estimatedRowHeight = 100
        contactListTable.rowHeight = UITableViewAutomaticDimension
        
        
        
        //Add refresh database
        refreshController.addTarget(self, action: #selector(refreshControlAction(refreshController:)), for: UIControlEvents.valueChanged)
        contactListTable.insertSubview(refreshController, at: 0)
        
        
    }
    
    
}
extension ContactListViewController{
    func loadContactList() {
        Api.shared().getMyFriendList().subscribe(onNext: { (User) in
            self.contactList.append(User)
            self.contactListTable.reloadData()
        }, onError: { (Error) in
            print(Error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil)
    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactListTable.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! ContactTableViewCell
        let user = contactList[indexPath.row]
        var statusImage = #imageLiteral(resourceName: "offline")
        
        cell.avatarImage.setImageWith(URL(string: user.avatar!)!, placeholderImage: nil)
        cell.nameLabel.text = user.name
        cell.captionLabel.text = user.caption
        
        
        if user.status == true {
            statusImage = #imageLiteral(resourceName: "online")
        }
        cell.statusImage.image = statusImage
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.height/2
        cell.statusImage.layer.zPosition = 1
        cell.avatarImage.layer.zPosition = 0
        cell.avatarImage.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = contactList[(indexPath.row)]
        tableView.deselectRow(at: indexPath, animated: true)
        //Remove the ThinhListViewController
        let previousVC = UIStoryboard(name: "ContactList", bundle: nil).instantiateViewController(withIdentifier: "ContactListViewController")
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //Add the New UserDetailViewController
        let vc = UIStoryboard(name: "UserDetail", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        vc.user = user  //Push user data to UserDetailViewController
        addChildViewController(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)

    }
    // Hides the RefreshControl
    func refreshControlAction(refreshController: UIRefreshControl) {
        self.refreshController.endRefreshing()
    }
}


