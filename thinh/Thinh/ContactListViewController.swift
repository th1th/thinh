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
    
    
    @IBOutlet weak var ThaThinhMessageTextView: UITextView!
    
    
    var grayBackgroundView = UIView()
    var popupView:ThaThinhMessageView?
    var popupViewDic:[String:ThaThinhMessageView] = [:]
    var constX:NSLayoutConstraint?
    var constY:NSLayoutConstraint?
    
    @IBAction func CompleteThathinhButton(_ sender: UIButton) {
        thathinhMessage = ThaThinhMessageTextView.text
        Api.shared().thathinh(thathinhUser!.id!, message: thathinhMessage, image: thathinhImage)
        hidePopupView()
    }
    
    var contactList = [User]()
    let refreshController = UIRefreshControl()
    var thathinhUser: User?
    var thathinhMessage: String!
    
    var thathinhImage: UIImage!
    
    
    var contactDict = [String:[User]]()
    var sectionTitles = [String]()
    let indexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListTable.sectionHeaderHeight = 12
        contactListTable.sectionIndexColor = UIColor.jsq_messageBubbleGreen()
        contactListTable.sectionIndexBackgroundColor = UIColor(white: 1, alpha: 0)
        
        
        
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
        contactListTable.dg_setPullToRefreshFillColor(UIColor(red: 225/255.0, green: 245/255.0, blue: 242/255.0, alpha: 1.0))
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
        Api.shared().getMyFriendList().subscribe(onNext: { (user) in
            
            let userName = user.name
            let initialLetter = userName?.substring(to: (userName?.index(after: (userName?.startIndex)!))!).uppercased()
            var userArray = self.contactDict[initialLetter!] ?? [User]()
            
            var isReplicated:Bool = false
            for (index, element) in userArray.enumerated() {
                if element.id == user.id {
                    // Replace user
                    isReplicated = true
                    userArray[index] = user
                }
            }
            if(!isReplicated){
                userArray.append(user)
            }
            self.contactDict[initialLetter!] = userArray
            
            self.sectionTitles = Array(self.contactDict.keys)
            self.sectionTitles = self.sectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            
//            self.contactList.append(user)
            self.contactListTable.reloadData()
        }, onError: { (Error) in
            print(Error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil)
    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactListTable.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! ContactTableViewCell
        
        let sectionTitle = self.sectionTitles[indexPath.section]
        let userArray = self.contactDict[sectionTitle]
        
        let user = userArray?[indexPath.row]
//        let user = contactList[indexPath.row]
        var statusImage = #imageLiteral(resourceName: "offline")
        
        cell.avatarImage.image = nil
        cell.avatarImage.setImageWith(URL(string: (user?.avatar!)!)!, placeholderImage: nil)
        cell.nameLabel.text = user?.name
        cell.captionLabel.text = user?.caption
        
        
        if user?.status == true {
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
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.sectionTitles.index(of: title) ?? NSNotFound
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 10)

            headerView.textLabel?.textColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contactList.count
        
        let sectionTitle = self.sectionTitles[section]
        let userArray = self.contactDict[sectionTitle]
        return userArray!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let user = contactList[(indexPath.row)]
        let sectionTitle = self.sectionTitles[indexPath.section]
        let userArray = self.contactDict[sectionTitle]
        let user = userArray?[indexPath.row]
        
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

        
//        if #available(iOS 10.0, *) {
//            let controller = UIStoryboard(name: "RecordVideo", bundle: nil).instantiateViewController(withIdentifier: "RecordVideoViewController")
//            self.present(controller, animated: true, completion: nil)
//        }else{
//            dismiss(animated: true, completion: {
//                utilities.log("only compatible with iOS 10 or above")
//            })
//        }
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
        thathinhImage = images[0]
        //show popup to user input the message
        showPopupView()
        //Api.shared().thathinh((thathinhUser?.id)!, image: image)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }

}

//setting pop up view
extension ContactListViewController{
    func configContentPopupView() {
            ThaThinhMessageTextView.text = "Say something :))"
            ThaThinhMessageTextView.font = UIFont(name: "SF UI Display Medium", size: 22)
    }
    func showPopupView(){
        
        
        //Show GrayView Behind popup view
        self.showGrayBGView(viewController: self, grayView: grayBackgroundView)
        
        //Load nib, and get reference to variable 'popupView'.
        popupView = Bundle.main.loadNibNamed("ThaThinhMessageView", owner: self, options: nil)?[0] as? ThaThinhMessageView
        
        self.view.addSubview(popupView!)
//        //delegate
//        captionTextView.delegate = self
//        phoneTextView.delegate = self
        
        //Configure popupview
        popupView?.frame.size = CGSize(width: 0, height: 0)
        popupView?.center = self.view.center
        popupView?.alpha = 0.5
        popupView?.clipsToBounds = true
        popupView?.layer.cornerRadius = 20
        
        
        //Autolayout part
        popupViewDic["ThaThinhMessageView"] = popupView
        
        var dView:[String:UIView] = [:]
        dView["ThaThinhMessageView"] = popupView
        
        popupView?.translatesAutoresizingMaskIntoConstraints = false
        
        let h_Pin = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[ThaThinhMessageView]-(12)-|", options: .alignAllTop, metrics: nil, views: dView)
        self.view.addConstraints(h_Pin)
        let v_Pin = NSLayoutConstraint.constraints(withVisualFormat:"V:|-(56)-[ThaThinhMessageView]-(56)-|", options: .alignAllTop, metrics: nil, views: dView)
        self.view.addConstraints(v_Pin)
        
        constY = NSLayoutConstraint(item: popupView!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constY!)
        
        
        constX = NSLayoutConstraint(item: popupView!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constX!)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.50, options: UIViewAnimationOptions.layoutSubviews, animations: { () -> Void in
            self.popupView?.alpha = 1
            self.view.layoutIfNeeded()
        }) { (value:Bool) -> Void in
            
        }
        
    }
    
    
    //Gray bg view configuration
    func showGrayBGView(viewController:UIViewController,grayView:UIView){
        
        let viewController:UIViewController = viewController
        let GrayView:UIView = grayView
        
        viewController.view.addSubview(GrayView)
        
        var dView:[String:UIView] = [:]
        dView["GrayView"] = GrayView
        
        GrayView.frame = viewController.view.frame
        GrayView.backgroundColor = UIColor.clear
        GrayView.translatesAutoresizingMaskIntoConstraints = (false)
        UIView.animate(withDuration: 0.5, animations: {
            GrayView.backgroundColor = UIColor.black
            GrayView.alpha = 0.75
        })
        
        let h_Pin = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-16)-[GrayView]-(-16)-|", options: .alignAllTop, metrics: nil, views: dView)
        viewController.view.addConstraints(h_Pin)
        
        let v_Pin = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-16)-[GrayView]-(-16)-|", options: .alignAllTop, metrics: nil, views: dView)
        viewController.view.addConstraints(v_Pin)
        
    }
    
    func hidePopupView(){
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.50, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            self.grayBackgroundView.alpha = 0
            self.popupView!.alpha = 0
            
        }) { (value:Bool) -> Void in
            self.popupView!.removeFromSuperview()
            self.grayBackgroundView.removeFromSuperview()
            
        }
        
    }
}




