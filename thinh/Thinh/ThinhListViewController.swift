//
//  ThinhListViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ThinhListViewController: UIViewController {

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserImage2: UIImageView!
    @IBOutlet weak var UserImage3: UIImageView!
    @IBOutlet weak var UserImage4: UIImageView!
    @IBOutlet weak var UserImage5: UIImageView!
    @IBOutlet weak var UserImage6: UIImageView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var acceptButton2: UIButton!
    @IBOutlet weak var acceptButton3: UIButton!
    @IBOutlet weak var acceptButton4: UIButton!
    @IBOutlet weak var acceptButton5: UIButton!
    @IBOutlet weak var acceptButton6: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var declineButton2: UIButton!
    @IBOutlet weak var declineButton3: UIButton!
    @IBOutlet weak var declineButton4: UIButton!
    @IBOutlet weak var declineButton5: UIButton!
    @IBOutlet weak var declineButton6: UIButton!
    
    
    var contentView: UIView! = nil
    var users: [User] = []
    var thinhs: [Thinh] = []
    
    var images: [UIImageView]!
    var acceptButtons: [UIButton]!
    var declineButtons: [UIButton]!

    var acceptButtonIDs = ["acceptForImage","acceptForImage2","acceptForImage3","acceptForImage4","acceptForImage5","acceptForImage6"]
    var declineButtonIDs = ["declineForImage","declineForImage2","declineForImage3","declineForImage4","declineForImage5","declineForImage6"]

    //Track the index of loaded user from thinh list
    //thinh list from server:
    // *************   *    *********************
    // \___________/   ^    \___________________/
    //  loaded user   track        unload user
    var indexTracking = 0
    
    
    
    
    @IBAction func onClickGetDetail(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 1
        sender.numberOfTouchesRequired = 1
        utilities.log("get detail of user at: \((sender.view?.tag)!)-----number of users: \(users.count)")
        let user = users[(sender.view?.tag)!]
        
        //Remove the ThinhListViewController
        let previousVC = UIStoryboard(name: "ThinhList", bundle: nil).instantiateViewController(withIdentifier: "ThinhListViewController")
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
    

    @IBAction func onClickedAccept(_ sender: UIButton) {
        if let buttonId = sender.restorationIdentifier{
            for index in 0..<acceptButtonIDs.count {
                if buttonId == acceptButtonIDs[index] {
                    utilities.log("reloadThinhList----accept thinh from user: \(users[index].id!) -- tag=\(index)")
                    Api.shared().thathinh(users[index].id!)
                    users.remove(at: index)
                    //update view
                    updateImage(tag: index)
                    print("index \(index)")
                    break
                }
            }
        }
    }
    @IBAction func onClickedDeline(_ sender: UIButton) {
        if let buttonId = sender.restorationIdentifier{
            for index in 0..<declineButtonIDs.count {
                if buttonId == declineButtonIDs[index] {
                    //Handle with FRB client
                    //.............waiting for function in client...  ~.~
                    Api.shared().dropThinh(users[index].id!)
                    users.remove(at: index)
                    //update view
                    updateImage(tag: index)
                    print(index)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: VIEW
extension ThinhListViewController{
    func initView() {
        images = [UserImage,UserImage2,UserImage3,UserImage4,UserImage5,UserImage6]
        acceptButtons = [acceptButton,acceptButton2,acceptButton3,acceptButton4,acceptButton5,acceptButton6]
        declineButtons = [declineButton,declineButton2,declineButton3,declineButton4,declineButton5,declineButton6]
        for image in images {
            image.layer.cornerRadius = (image.frame.height)/2 //set corner for image here
            image.clipsToBounds = true
        }
        reloadThinhList()
    }
    //Get Thinh from server and add to list users
    func reloadThinhList() {
        hideUnuseThinhView()
        //GET ALL THINH HERE:
        utilities.log("reloadThinhList---   \(User.currentUser.id)")
        Api.shared().getMyStrangerThinh().subscribe(onNext: { (thinh:Thinh) in
            utilities.log("reloadThinhList--\(thinh)")
            Api.shared().getUser(id: thinh.from!).subscribe(onNext: { (user) in
                self.thinhs.append(thinh)
                self.users.append(user)
                utilities.log("reloadThinhList--- number of thinh:\(self.users.count)")
                self.loadUserToView()
                self.hideUnuseThinhView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            //            self.indexTracking =
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil)
    }

    //Load all image of users (when fisrt load Thinh list view)
    func loadUserToView()  {
        var counter = 6
        for index in 0..<counter {
            images[index].image = #imageLiteral(resourceName: "gray")
        }
        if (users.count - indexTracking)<6 {
            counter = users.count - indexTracking
            utilities.log("loadUserToView-- users: \(users.count)")
            utilities.log("loadUserToView--        \(users)")
            utilities.log("loadUserToView--        \(counter)")
        }
        
        for index in 0..<counter {
            utilities.log("loadUserToView-- update avatar for: \(users[index].name)")
            images[index].af_setImage(withURL: URL(string: users[index].avatar!)!)
//            indexTracking += 1
        }
    }
    
    //Function is used to change image when user accept/decline, after load new user and remove old user
    func updateImage(tag: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: [], animations: {
            self.images[tag].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.acceptButtons[tag].alpha = 0
            self.declineButtons[tag].alpha = 0
        }) { (result) in
            if tag >= self.users.count - 1 {
                utilities.log("updateImage-- \(self.users.count)++ End of list ++tag \(tag)")
                self.images[tag].isHidden = true
                self.hideUnuseThinhView()
            }else{
                utilities.log("updateImage-- \(self.users.count)++tag \(tag)")
                self.images[tag].af_setImage(withURL: URL(string: self.users[tag+1].avatar!)!)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: [], animations: {
                self.images[tag].transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: {(result) in
                self.acceptButtons[tag].alpha = 1
                self.declineButtons[tag].alpha = 1
            })
        }
    }
    func hideUnuseThinhView() {
        for index in 0..<6 {
            images[index].isHidden = true
            acceptButtons[index].isHidden = true
            declineButtons[index].isHidden = true
            images[index].image = nil
//            blurEffect(currentView: images[index])
            
        }
        for index in 0..<users.count {
            if index == 6 {
                return
            }
            images[index].isHidden = false
            acceptButtons[index].isHidden = false
            declineButtons[index].isHidden = false
        }
    }
//    func blurEffect(currentView: UIView) {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = currentView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        currentView.addSubview(blurEffectView)
//    }
    
}

















