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
        utilities.log((sender.view?.tag)!)
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
                    acceptThinh(tag: index)
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
                    declineThinh(tag: index)
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

extension ThinhListViewController{
    func acceptThinh(tag: Int) {
        //Handle with FRB client
        //.............waiting for function in client...  ~.~
        
        
        //update view
        updateImage(tag: tag)
    }
    func declineThinh(tag: Int) {
        //Handle with FRB client
        //.............waiting for function in client...  ~.~
        
        
        //update view
        updateImage(tag: tag)
        //update user
//        for index in tag..<users.count{
//            users[index] = users[index+1]
//        }
//        loadUserToView()
    }
}

extension ThinhListViewController{
    
    //Get Thinh from server and add to list users
    func getThinhList() {
        //GET ALL THINH HERE:
        print(User.currentUser.id)
        Api.shared().getStrangerThinh().subscribe(onNext: { (thinh:Thinh) in
            print(thinh)
            Api.shared().getUser(id: thinh.from!).subscribe(onNext: { (user) in
                self.thinhs.append(thinh)
                self.users.append(user)
                self.loadUserToView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            self.indexTracking = 
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            //
        }) {
            //
        }
//        users += User.mock()
    }
    
    //Load all image of users (when fisrt load Thinh list view)
    func loadUserToView()  {
        images = [UserImage,UserImage2,UserImage3,UserImage4,UserImage5,UserImage6]
        acceptButtons = [acceptButton,acceptButton2,acceptButton3,acceptButton4,acceptButton5,acceptButton6]
        declineButtons = [declineButton,declineButton2,declineButton3,declineButton4,declineButton5,declineButton6]
        for index in 0..<users.count {
            images[index].setImageWith(URL(string: users[index].avatar!)!)
        }
    }
    
    //Function is used to change image when user accept/decline, after load new user and remove old user
    func updateImage(tag: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: [], animations: {
            self.images[tag].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.acceptButtons[tag].alpha = 0
            self.declineButtons[tag].alpha = 0
        }) { (result) in
            self.images[tag].setImageWith(URL(string: self.users[tag].avatar!)!)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: [], animations: {
                self.images[tag].transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: {(result) in
                self.acceptButtons[tag].alpha = 1
                self.declineButtons[tag].alpha = 1
            })
        }
    }

    func initView() {
        for image in [UserImage,UserImage2,UserImage3,UserImage4,UserImage5,UserImage6] {
            image?.layer.cornerRadius = (image?.frame.height)!/2 //set corner for image here
            image?.clipsToBounds = true
        }
        getThinhList()
        loadUserToView()
    }
}













