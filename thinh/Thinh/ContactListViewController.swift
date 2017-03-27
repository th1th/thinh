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

    var contactList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListTable.delegate = self
        contactListTable.dataSource = self
        
        loadContactList()
        contactListTable.reloadData()
    }
    
    
}
extension ContactListViewController{
    func loadContactList() {
        ////
        //.......waiting for api
        contactList = User.mock()

    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactListTable.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! ContactTableViewCell
        let user = contactList[indexPath.row]
        
        cell.avatarImage.setImageWith(URL(string: user.avatar!)!, placeholderImage: nil)
        cell.nameLabel.text = user.name
        cell.captionLabel.text = user.caption
        
        
        let statusImage = #imageLiteral(resourceName: "offline")
        cell.statusImage.image = statusImage

        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.height/2
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
}


