//
//  ViewController.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/11/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import AFNetworking
import Firebase
import RxSwift

class LoginViewController: UIViewController {
    
    
    var accessToken: AccessToken?
    var user: FIRUser?
    var loginState = false
    var fbUserID: String?
    fileprivate var disposeBag: DisposeBag! = DisposeBag()
    
    
    let defaults = UserDefaults.standard
    
    //Outlet
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarHeighContrain: NSLayoutConstraint!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var avatarWidthContrain: NSLayoutConstraint!
    
    //Action
    @IBAction func onClickedLoginButton(_ sender: UIButton) {

        loginViaFb()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let accessToken = defaults.string(forKey: "Thinh_CurrentUser"){
            firebaseSigin(accessToken)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
}
///Core function
extension LoginViewController{
    func firebaseSigin(_ accessToken: String) {
        Api.shared().login(accessToken: accessToken).subscribe(onNext: { (user) in
            print("Login success")
            User.currentUser = user
            self.updateAvatar(user.avatar ?? "")
            self.blurEffect()
            
        }, onError: { (error) in
            print("Login failed")
        }).addDisposableTo(disposeBag)
    }
}

///Animation
extension LoginViewController{
    func loginViaFb() {
        LoginManager().logIn([.publicProfile,.userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("[fb] \(error)")
            case .cancelled:
                print("[fb] User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("[fb]: \(grantedPermissions)  \(declinedPermissions)")
                print("[fb] Logged in!")
                print("[xx]\(accessToken.userId)")
                self.defaults.set(accessToken.userId, forKey: "Thinh_FBuserID")
                self.defaults.set(accessToken.authenticationToken, forKey: "Thinh_CurrentUser")
                self.firebaseSigin(accessToken.authenticationToken)
                print("fb id \(accessToken.userId)")
            }
        }
    }
    func updateAvatar(_ avatar: String)  {
//        let photoUrl = URL(string: "https://graph.facebook.com/\(fbid!)/picture?type=large")
        let photoUrl = URL(string: avatar)
        print("[xx]\(photoUrl)")
        
        
        Api.shared().updateUserStatus(true)

        self.avatarHeighContrain.constant = 100
        self.avatarWidthContrain.constant = 100
        self.avatarImage.layer.masksToBounds = true
        self.avatarImage.layer.cornerRadius = CGFloat(50)
        
        self.avatarImage.setImageWith(photoUrl!)
        self.avatarImage.sizeToFit()
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: [], animations: { () -> Void in
            self.avatarImage.transform = self.avatarImage.transform.scaledBy(x: 1.1, y: 1.1)
        },completion: { (Bool) -> Void in
            self.avatarImage.transform = self.avatarImage.transform.scaledBy(x: 1, y: 1)
            self.performSegue(withIdentifier: "logedIn", sender: nil)

        })
    }
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundImage.addSubview(blurEffectView)
    }
}
