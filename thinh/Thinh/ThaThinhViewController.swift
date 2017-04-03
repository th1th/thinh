//
//  ThaThinhViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/28/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import DZNEmptyDataSet
import AVFoundation
import MediaPlayer
import MobileCoreServices

class ThaThinhViewController: UIViewController {

    @IBOutlet weak var UserImage1: UIImageView!
    @IBOutlet weak var UserImage2: UIImageView!
    @IBOutlet weak var UserImage3: UIImageView!
    @IBOutlet weak var UserImage4: UIImageView!

    @IBOutlet weak var ThathinhButton1: UIButton!
    @IBOutlet weak var ThathinhButton2: UIButton!
    @IBOutlet weak var ThathinhButton3: UIButton!
    @IBOutlet weak var ThathinhButton4: UIButton!
    

    @IBOutlet weak var cacheImage: UIImageView!
    
    @IBOutlet weak var refreshLabe: UILabel!
    
    var images: [UIImageView]! = []
    var buttons: [UIButton]! = []
    var allUsers: [User]! = []
    var showUsers: [User]! = []
    
    var tracking = 0
    //For remove unlike user
    var UserImageOriginalCenter: CGPoint!
    var RefreshImageCenter:CGPoint!
    

    
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
    @IBAction func onRefreshPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        self.view.bringSubview(toFront: sender.view!)
        if sender.state == UIGestureRecognizerState.began {
            print("refresh began at \(point)")
            RefreshImageCenter = sender.view?.center
        } else if sender.state == UIGestureRecognizerState.changed {
            print("refresh changed at \(point)")
            if translation.y < 40 {
                sender.view?.center = CGPoint(x: RefreshImageCenter.x, y: RefreshImageCenter.y + translation.y)
            }
            
        } else if sender.state == UIGestureRecognizerState.ended {
            print("refresh ended at \(point)")
            refreshLabe.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [], animations: {
                sender.view?.center = self.RefreshImageCenter
                self.allUsers.remove(at: (sender.view?.tag)!)
                self.allUsers.remove(at: (sender.view?.tag)!)
                self.allUsers.remove(at: (sender.view?.tag)!)
                self.allUsers.remove(at: (sender.view?.tag)!)
                if self.allUsers.count<4 {
                    self.loadMoreUser()
                }
                self.refreshLabe.alpha = 1
            }, completion: { (_) in
                self.view.sendSubview(toBack: sender.view!)
                self.reloadUserToShowUser()
            })
        }
    }
    
    @IBAction func onUserPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let button = buttons[(sender.view?.tag)!]
        self.view.bringSubview(toFront: sender.view!)
        if sender.state == UIGestureRecognizerState.began {
            print("Gesture began at \(point)")
            UserImageOriginalCenter = sender.view?.center
            button.isHidden = true
        } else if sender.state == UIGestureRecognizerState.changed {
            print("Gesture changed at \(point)")
            sender.view?.center = CGPoint(x: UserImageOriginalCenter.x+translation.x, y: UserImageOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.ended {
            print("Gesture ended at \(point)")
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [], animations: {
                if velocity.x>0{
                    sender.view?.alpha = 0
                }else{
                    sender.view?.center = self.UserImageOriginalCenter
                }
                
            }, completion: { (_) in
                sender.view?.center = self.UserImageOriginalCenter
                sender.view?.alpha = 1
                self.view.sendSubview(toBack: sender.view!)
                button.isHidden = false
                if velocity.x>0{
                    self.allUsers.remove(at: (sender.view?.tag)!)
                    self.reloadUserToShowUser()                }
            })
        }
    }

    @IBAction func onLongPressThaThinh(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    @IBAction func ThaThinh(_ sender: UIButton) {
        var index = sender.tag
        utilities.log("tha thinh: \(allUsers[index].name))")
        Api.shared().thathinh(allUsers[index].id!)
        allUsers.remove(at: index)
        reloadUserToShowUser()
        if allUsers.count<4 {
            loadMoreUser()
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
extension ThaThinhViewController{
    func initView() {
        images = [UserImage1,UserImage2,UserImage3,UserImage4]
        buttons = [ThathinhButton1,ThathinhButton2,ThathinhButton3,ThathinhButton4]
        for image in images {
            image.layer.cornerRadius = (image.frame.height)/18 //set corner for image
            image.clipsToBounds = true
        }
        getUserFromServer()
    }
    func getUserFromServer() {
        allUsers = []
        Api.shared().getMyStrangerList().subscribe(onNext: { (user) in
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
        if allUsers.count>maximumShowUser {
            cacheImage.setImageWith(URL(string: allUsers[maximumShowUser].avatar!)!)
        }
        hideUnuseView()
    }
    func hideUnuseView() {
        if allUsers.count<4 {
            for index in 0..<allUsers.count-1 {
                images[index].isHidden = false
                buttons[index].isHidden = false
            }
            for index in (allUsers.count-1)..<4 {
                images[index].isHidden = true
                buttons[index].isHidden = true
            }
        }else{
            
            for index in 0..<4 {
                images[index].isHidden = false
                buttons[index].isHidden = false
            }
        }
    }
    func loadMoreUser() {
        getUserFromServer()
    }
    
}
extension ThaThinhViewController{

}
