//
//  ThaThinhViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/28/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ThaThinhViewController: UIViewController {

    @IBOutlet weak var UserImage1: UIImageView!
    @IBOutlet weak var UserImage2: UIImageView!
    @IBOutlet weak var UserImage3: UIImageView!
    @IBOutlet weak var UserImage4: UIImageView!
    
    var images: [UIImageView]! = []
    var allUsers: [User]! = []
    var showUsers: [User]! = []
    
    var tracking = 0
    
    
    @IBAction func onClickGetDetail(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 1
        sender.numberOfTouchesRequired = 1
        print("\(sender.view?.tag)")
        utilities.log("get detail of user at: \((sender.view?.tag)!)")
        let user = showUsers[(sender.view?.tag)!]
        
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
    
    

    
    @IBAction func ThaThinh(_ sender: UIButton) {
        var index = sender.tag
        

        Api.shared().thathinh(allUsers[index].id!)
        allUsers.remove(at: index)
        reloadUserToShowUser()

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
extension ThaThinhViewController{
    func initView() {
        images = [UserImage1,UserImage2,UserImage3,UserImage4]
        for image in images {
            image.layer.cornerRadius = (image.frame.height)/18 //set corner for image
            image.clipsToBounds = true
        }
        getUserFromServer()
    }
    func getUserFromServer() {
        allUsers = []
        Api.shared().getAllUser().subscribe(onNext: { (user) in
            self.allUsers.append(user)
            utilities.log("getUserFromServer--  get \(self.allUsers.count) users")
            self.reloadUserToShowUser()
        }, onError: { (error) in
            utilities.log("getUserFromServer--\(error.localizedDescription)")
        }, onCompleted: nil, onDisposed: nil)
    }
    func reloadUserToShowUser() {
        showUsers = []
        var maximumShowUser = 4
        
        if allUsers.count < 4 {
            maximumShowUser = allUsers.count
        }
        utilities.log("reloadUserToShowUser--- maximum=\(maximumShowUser)")
        for index in 0..<maximumShowUser {
            utilities.log("reloadUserToShowUser--- index=\(index)")
            showUsers.append(allUsers[index])

            UIView.transition(with: self.images[index],
                              duration: 0.7,
                              options: .transitionCrossDissolve,
                              animations: {
                              self.images[index].setImageWith(URL(string:self.showUsers[index].avatar!)!)
            },
                              completion: nil)
        }
        
    }
    
}
