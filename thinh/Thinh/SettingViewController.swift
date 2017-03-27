//
//  SettingViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Firebase

import FacebookLogin
//import FacebookCore

class SettingViewController: UIViewController {
    var grayBackgroundView = UIView()
    var popupView:PopupView?
    var popupViewDic:[String:PopupView] = [:]
    
    var constX:NSLayoutConstraint?
    var constY:NSLayoutConstraint?
    
    @IBOutlet weak var UserBackgroundImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserCaptionLabel: UILabel!
    @IBOutlet weak var UserInfoLabel: UILabel!
    
    var user:User? = nil

    
    @IBAction func showPopUp(_ sender: UIButton) {
        self.showPopupView()
        configContentPopupView()

    }
    @IBAction func Done(_ sender: UIButton) {
        updateUserInfo()
        loadInfo()
        hidePopupView()
    }
    
    @IBAction func close(_ sender: UIButton) {
        hidePopupView()
    }
    //Popup View outlet
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadUser()
        loadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//load user info
extension SettingViewController{
    
    func loadUser() {
        user = User.currentUser
    }

    func loadInfo() {
        //UserBackgroundImage.setImageWith(URL(string: (user?.avatar)!)!)
        AvatarImage.setImageWith(URL(string: (user?.avatar)!)!)
        UserNameLabel.text = user?.name
        UserCaptionLabel.text = user?.caption
        UserInfoLabel.text = user?.name
        
        UserBackgroundImage.image = #imageLiteral(resourceName: "Background")
        
        
        //
        AvatarImage.layer.cornerRadius = AvatarImage.frame.height/2
        AvatarImage.clipsToBounds = true
        AvatarImage.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 0.5).cgColor
        AvatarImage.layer.borderWidth = 1.0
        //
        
        UserCaptionLabel.clipsToBounds = true
        UserCaptionLabel.layer.cornerRadius = 8
        UserCaptionLabel.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:255/255, alpha: 0.5).cgColor
        UserCaptionLabel.layer.borderWidth = 1.0
        
    }
    func updateUserInfo() {
        user?.caption = captionTextView.text
        user?.gender = User.Sex(rawValue: genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)!)
        user?.phone = phoneTextView.text
    }
    func signOut() {
        let firebaseAuth = FIRAuth.auth()
        let defaults = UserDefaults.standard
        
        do {
            LoginManager().logOut()
            defaults.set(nil, forKey: "Thinh_CurrentUser")
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLogOut"), object: nil)
        
    }
}



//setting pop up view
extension SettingViewController{
    func configContentPopupView() {
        if let tempUser = user {
            captionTextView.text = tempUser.caption ?? "Unknown"
            phoneTextView.text = tempUser.phone ?? "Unknown"
            //genderSegment.selectedSegmentIndex = (tempUser.gender?.hashValue)! ?? 2
        }else{
            captionTextView.text = "song noi tam yeu mau tim"
            phoneTextView.text = "unknown"
            genderSegment.selectedSegmentIndex = 2
        }
    }
    func showPopupView(){
        
        //Show GrayView Behind popup view
        self.showGrayBGView(viewController: self, grayView: grayBackgroundView)
        
        //Load nib, and get reference to variable 'popupView'.
        popupView = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)?[0] as? PopupView
        
        self.view.addSubview(popupView!)
        
        //Configure popupview
        popupView?.frame.size = CGSize(width: 0, height: 0)
        popupView?.center = self.view.center
        popupView?.alpha = 0.5
        popupView?.clipsToBounds = true
        popupView?.layer.cornerRadius = 20
        
        
        //Autolayout part
        popupViewDic["popupView"] = popupView
        
        var dView:[String:UIView] = [:]
        dView["popupView"] = popupView
        
        popupView?.translatesAutoresizingMaskIntoConstraints = false
        
        let h_Pin = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[popupView]-(12)-|", options: .alignAllTop, metrics: nil, views: dView)
        self.view.addConstraints(h_Pin)
        let v_Pin = NSLayoutConstraint.constraints(withVisualFormat:"V:|-(36)-[popupView]-(36)-|", options: .alignAllTop, metrics: nil, views: dView)
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
