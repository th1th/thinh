//
//  SettingViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Firebase

import DGElasticPullToRefresh
import DZNEmptyDataSet
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
    @IBOutlet weak var UserCaptionView: UIView!
    
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    @IBOutlet weak var GenderLabel: UILabel!
    @IBOutlet weak var GenderImage: UIImageView!
    @IBOutlet weak var PreferLabel: UILabel!
    @IBOutlet weak var PreferImage: UIImageView!
    @IBOutlet weak var InfoView: UIView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var user:User? = nil
    var sex:[UIImage]! = []
    
    @IBAction func createMockData(_ sender: UIButton) {
        Api.shared().createMockData()
    }
    
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
    @IBAction func signoutButton(_ sender: UIButton) {
        signOut()
    }
    
    //Popup View outlet
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var preferSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add refresh database
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        ScrollView.dg_addPullToRefreshWithActionHandler({
            utilities.log(User.currentUser.id ?? "cannot get currentUser id")
            Api.shared().getUser(id: User.currentUser.id!).subscribe(onNext: { (user) in
                self.loadUser()
            }, onError: { (error) in
                utilities.log(error)
            }, onCompleted: nil, onDisposed: nil)

            self.ScrollView.dg_stopLoading()
        }, loadingView: loadingView)
        ScrollView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        //ScrollView.dg_setPullToRefreshBackgroundColor(ScrollView.backgroundColor!)


        // Do any additional setup after loading the view.
        loadUser()
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
        utilities.log("current user id: \(User.currentUser.id)")
        Api.shared().getUser(id: User.currentUser.id!).subscribe(onNext: { (user) in
            if let userID = user.id{
                self.user = user
            }else{
                self.user = User.currentUser
            }
            self.loadInfo()
        }, onError: { (error) in
            utilities.log(error)
        }, onCompleted: nil, onDisposed: nil)

    }

    func loadInfo() {
        AvatarImage.alpha = 0
        UserCaptionView.alpha = 0
        InfoView.alpha = 0
        
        sex = [#imageLiteral(resourceName: "male"),#imageLiteral(resourceName: "female"),#imageLiteral(resourceName: "biosex")]
        //UserBackgroundImage.setImageWith(URL(string: (user?.avatar)!)!)
        AvatarImage.setImageWith(URL(string: (user?.avatar)!)!)
        UserNameLabel.text = user?.name
        if let caption = user?.caption {
            UserCaptionLabel.text = caption
            if UserCaptionLabel.text == "" {
                UserCaptionLabel.text = user?.caption ?? "What's in your mind? 😳"
            }
        }
        user?.phone = user?.phone ?? "Secret 😉"
        user?.gender = user?.gender ?? User.Sex(rawValue: "unknown")!
        user?.prefer = user?.prefer ?? User.Sex(rawValue: "unknown")!
        
        PhoneNumberLabel.text = "Phone: \(user!.phone!)"
        GenderLabel.text =      "\((user!.gender)!.rawValue)"
        PreferLabel.text =      "\((user!.prefer)!.rawValue)"
        GenderImage.image = sex[(user?.gender?.hashValue) ?? 3]
        PreferImage.image = sex[(user?.prefer?.hashValue) ?? 3]
        UserBackgroundImage.image = #imageLiteral(resourceName: "Background")
        
        
        //
        AvatarImage.layer.cornerRadius = AvatarImage.frame.height/2
        AvatarImage.clipsToBounds = true
        AvatarImage.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 0.5).cgColor
        AvatarImage.layer.borderWidth = 1.0
        //
        
        UserCaptionView.clipsToBounds = true
        UserCaptionView.layer.cornerRadius = 8
        UserCaptionView.layer.borderColor = UIColor( red: 170/255, green: 254/255, blue:235/255, alpha: 0.5).cgColor
        UserCaptionView.layer.borderWidth = 1.0
        UserCaptionView.backgroundColor = UIColor( red: 166/255, green: 229/255, blue:217/255, alpha: 0.5)
        
        InfoView.clipsToBounds = true
        InfoView.layer.cornerRadius = 8
        InfoView.layer.borderColor = UIColor( red: 170/255, green: 254/255, blue:235/255, alpha: 0.5).cgColor
        InfoView.layer.borderWidth = 1.0
        InfoView.backgroundColor = UIColor( red: 201/255, green: 243/255, blue:222/255, alpha: 0.5)
        
        
        UIView.transition(with: self.AvatarImage,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.AvatarImage.alpha = 1
        }){ (result) in
            UIView.transition(with: self.UserCaptionView,
                              duration: 0.7,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.UserCaptionView.alpha = 1
            }) { (result) in
                UIView.transition(with: self.InfoView,
                                  duration: 0.7,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.InfoView.alpha = 1
                }, completion: nil)
            }
        }

        //View for Edit profile
        
        
    }
    func updateUserInfo() {
        let sex = ["male","female","unknown"]
        
        user?.caption = captionTextView.text
        user?.gender = User.Sex(rawValue: sex[genderSegment.selectedSegmentIndex])
        user?.prefer = User.Sex(rawValue: sex[preferSegment.selectedSegmentIndex])
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
            captionTextView.text = tempUser.caption ?? "What's in your mind? 😳"
            phoneTextView.text = tempUser.phone ?? "Secret 😉"
            genderSegment.selectedSegmentIndex = (tempUser.gender?.hashValue) ?? 2
            preferSegment.selectedSegmentIndex = (tempUser.prefer?.hashValue) ?? 0
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
        //delegate
        captionTextView.delegate = self
        phoneTextView.delegate = self
        
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
        let v_Pin = NSLayoutConstraint.constraints(withVisualFormat:"V:|-(56)-[popupView]-(56)-|", options: .alignAllTop, metrics: nil, views: dView)
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

extension SettingViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}

