//
//  ContactListViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/26/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import DZNEmptyDataSet
import AVFoundation
import MediaPlayer
import MobileCoreServices
import ImagePicker

class ContactListViewController: UIViewController {

    @IBOutlet weak var contactListTable: UITableView!
    
    var contactList = [User]()
    let refreshController = UIRefreshControl()
    var thathinhUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListTable.delegate = self
        contactListTable.dataSource = self
        
        loadContactList()
        contactListTable.reloadData()
        
        contactListTable.estimatedRowHeight = 100
        contactListTable.rowHeight = UITableViewAutomaticDimension
        
        
        
        
        //Add refresh database
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        contactListTable.dg_addPullToRefreshWithActionHandler({ 
            self.contactListTable.dg_stopLoading()
        }, loadingView: loadingView)
        contactListTable.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        contactListTable.dg_setPullToRefreshBackgroundColor(contactListTable.backgroundColor!)

        //Add refresh database
//        refreshController.addTarget(self, action: #selector(refreshControlAction(refreshController:)), for: UIControlEvents.valueChanged)
//        contactListTable.insertSubview(refreshController, at: 0)
        
        
    }
    deinit {
        self.contactListTable.dg_removePullToRefresh()
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
        cell.user = user
        cell.delegate = self
        
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
    
    //Tha Thinh with image
    func contactTableViewCellDelegate(user: User) {
        
        utilities.log(user)
        thathinhUser = user
        takePhoto()
        /*
        if #available(iOS 10.0, *) {
         
            
            let controller = UIStoryboard(name: "RecordVideo", bundle: nil).instantiateViewController(withIdentifier: "RecordVideoViewController")
            self.present(controller, animated: true, completion: nil)
            
            
        }else{
            dismiss(animated: true, completion: {
                utilities.log("only compatible with iOS 10 or above")
            })
        }*/
    }
}


extension ContactListViewController:ContactTableViewCellDelegate,ImagePickerDelegate{
    func takePhoto()  {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion:nil)
    }
    public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = images[0]
        Api.shared().thathinh((thathinhUser?.id)!, image: image)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }

}

//extension ContactListViewController:DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "NO MESSAGE"
//        
//        let attribs = [
//            NSFontAttributeName: UIFont.systemFont(ofSize: 25),
//            NSForegroundColorAttributeName: UIColor.white
//        ]
//        
//        return NSAttributedString(string: text, attributes: attribs)
//    }
//    
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "GETTING NO MESSAGE IS ALSO A MESSAGE"
//        
//        let para = NSMutableParagraphStyle()
//        para.lineBreakMode = NSLineBreakMode.byWordWrapping
//        para.alignment = NSTextAlignment.center
//        
//        let attribs = [
//            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
//            NSForegroundColorAttributeName: UIColor.white,
//            NSParagraphStyleAttributeName: para
//        ]
//        
//        return NSAttributedString(string: text, attributes: attribs)
//    }
//    
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        let text = "Start Tha Thinh !"
//        let attribs = [
//            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
//            NSForegroundColorAttributeName: view.tintColor
//            ] as [String : Any]
//        
//        return NSAttributedString(string: text, attributes: attribs)
//        
//    }
//    
//    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
//        print("Tapped")
//    }
//    
//    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//        return UIColor.gray
//    }
//    
//}



