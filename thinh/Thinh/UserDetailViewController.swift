//
//  UserDetailViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import AFNetworking

class UserDetailViewController: UIViewController {

    
    @IBOutlet weak var UserBackgroundImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserCaptionLabel: UILabel!
    @IBOutlet weak var UserInfoLabel: UILabel!
    
    var user:User? = nil
    
    
    @IBAction func onClickThaThinhButton(_ sender: UIButton) {
    }
    
    @IBAction func onClickClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadMockInfo()
        loadInfo()
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
    func loadMockInfo() {
        user = User.mock()[0]
    }

}
