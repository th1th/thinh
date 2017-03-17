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
class LoginViewController: UIViewController {
    

    @IBAction func onClickedLoginButton(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("[fb] \(error)")
            case .cancelled:
                print("[fb] User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("[fb] Logged in!")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension LoginViewController{

    
}
