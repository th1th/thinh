//
//  UserDetailViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import AFNetworking
import DGElasticPullToRefresh
import DZNEmptyDataSet

class UserDetailViewController: UIViewController {

    
    @IBOutlet weak var UserBackgroundImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserCaptionLabel: UILabel!
    @IBOutlet weak var UserInfoLabel: UILabel!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    var user:User? = nil
    @IBAction func closeView(_ sender: UIButton) {
        //Remove the Previous ViewController and Set Button State.
        let vc = self
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    
    @IBAction func onClickThaThinhButton(_ sender: UIButton) {
        print("[xx]thathinh")
        Api.shared().thathinh((user?.id)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add refresh database
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        ScrollView.dg_addPullToRefreshWithActionHandler({
            self.ScrollView.dg_stopLoading()
        }, loadingView: loadingView)
        ScrollView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        //ScrollView.dg_setPullToRefreshBackgroundColor(ScrollView.backgroundColor!)
        
        // Do any additional setup after loading the view.
        loadMockInfo()
        loadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func loadMockInfo() {
//        user = User.mock2()[0]
    }

}
