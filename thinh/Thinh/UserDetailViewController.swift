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
    @IBOutlet weak var UserCaptionView: UIView!
    @IBOutlet weak var ThaThinhButton: UIButton!
    
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    @IBOutlet weak var GenderLabel: UILabel!
    @IBOutlet weak var GenderImage: UIImageView!
    @IBOutlet weak var PreferLabel: UILabel!
    @IBOutlet weak var PreferImage: UIImageView!
    @IBOutlet weak var InfoView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    weak var user: User? = nil
    private let sex = [#imageLiteral(resourceName: "male"),#imageLiteral(resourceName: "female"),#imageLiteral(resourceName: "biosex")]
    
    var showCloseButton: Bool = true
    
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
        UIView.transition(with: self.ThaThinhButton.imageView!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.ThaThinhButton.imageView?.image = UIImage(named: "ThaThinh")
        },
                          completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Add refresh database
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        ScrollView.dg_addPullToRefreshWithActionHandler({
            self.ScrollView.dg_stopLoading()
        }, loadingView: loadingView)
        ScrollView.dg_setPullToRefreshFillColor(UIColor(red: 217/255.0, green: 243/255.0, blue: 239/255.0, alpha: 1.0))
        //ScrollView.dg_setPullToRefreshBackgroundColor(ScrollView.backgroundColor!)
        
        // Do any additional setup after loading the view.
        loadMockInfo()
        loadInfo()
        
        if showCloseButton == false {
            closeButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadInfo() {
        AvatarImage.alpha = 0
        UserCaptionView.alpha = 0
        InfoView.alpha = 0
        

        //UserBackgroundImage.setImageWith(URL(string: (user?.avatar)!)!)
        AvatarImage.setImageWith(URL(string: (user?.avatar)!)!)
        UserNameLabel.text = user?.name
        if let caption = user?.caption {
            UserCaptionLabel.text = caption
            if UserCaptionLabel.text == "" {
                UserCaptionLabel.text = user?.caption ?? "Tha Thinh me 😝"
            }
        }
        user?.phone = user?.phone ?? "Secret 😉"
        
        PhoneNumberLabel.text = "Phone: \(user!.phone!)"
        GenderLabel.text =      "\((user!.gender)!.rawValue)"
        PreferLabel.text =      "\((user!.prefer)!.rawValue)"
        GenderImage.image = sex[(user?.gender?.hashValue)!]
        PreferImage.image = sex[(user?.prefer?.hashValue)!]
        UserBackgroundImage.image = #imageLiteral(resourceName: "gray")
        if let cover = user?.cover {
            UserBackgroundImage.setImageWith(cover)
        }else{
            UserBackgroundImage.image = #imageLiteral(resourceName: "Background")
        }
        
        AvatarImage.layer.cornerRadius = AvatarImage.frame.height/2
        AvatarImage.clipsToBounds = true
        AvatarImage.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 0.5).cgColor
        AvatarImage.layer.borderWidth = 1.0
        
        
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
        //
        UIView.transition(with: self.AvatarImage,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.AvatarImage.alpha = 1
        }, completion: nil)
        UIView.transition(with: self.UserCaptionView,
                          duration: 0.7,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.UserCaptionView.alpha = 1
        }, completion: nil)
        UIView.transition(with: self.InfoView,
                          duration: 0.7,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.InfoView.alpha = 1
        }, completion: nil)
        
//        view.backgroundColor = UIColor( red: 122/255, green: 215/255, blue:253/255, alpha: 1)

    }
    func loadMockInfo() {
//        user = User.mock2()[0]
    }

}
