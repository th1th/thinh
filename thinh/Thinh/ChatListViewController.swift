//
//  ChatListViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/18/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class ChatListViewController: UIViewController {

    @IBAction func onClickedSignOut(_ sender: UIBarButtonItem) {
        signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatListViewController{
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
