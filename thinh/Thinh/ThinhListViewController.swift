//
//  ThinhListViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ThinhListViewController: UIViewController {

    
    
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserImage2: UIImageView!
    @IBOutlet weak var UserImage3: UIImageView!
    @IBOutlet weak var UserImage4: UIImageView!
    @IBOutlet weak var UserImage5: UIImageView!
    @IBOutlet weak var UserImage6: UIImageView!
    
    var contentView: UIView! = nil
    var users: [User] = []
    
    
    @IBAction func onClickGetDetail(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 1
        sender.numberOfTouchesRequired = 1
        print("[xx]tap")
        //Remove the Previous ViewController
        let previousVC = UIStoryboard(name: "ThinhList", bundle: nil).instantiateViewController(withIdentifier: "ThinhListViewController")
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //Add the New ViewController
        let vc = UIStoryboard(name: "UserDetail", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController")
        addChildViewController(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    

    @IBAction func onClickedAccept(_ sender: UIButton) {
        if let buttonId = sender.restorationIdentifier{
            switch buttonId {
            case "acceptForImage":
                print(buttonId)
                break
            case "acceptForImage2":
                print(buttonId)
                break
            case "acceptForImage3":
                print(buttonId)
                break
            case "acceptForImage4":
                print(buttonId)
                break
            case "acceptForImage5":
                print(buttonId)
                break
            case "acceptForImage6":
                print(buttonId)
                break
            default:
                break
            }
        }
    }
    @IBAction func onClickedDeline(_ sender: UIButton) {
        if let buttonId = sender.restorationIdentifier{
            switch buttonId {
            case "declineForImage":
                print(buttonId)
                break
            case "declineForImage2":
                print(buttonId)
                break
            case "declineForImage3":
                print(buttonId)
                break
            case "declineForImage4":
                print(buttonId)
                break
            case "declineForImage5":
                print(buttonId)
                break
            case "declineForImage6":
                print(buttonId)
                break
            default:
                break
            }
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

extension ThinhListViewController{
    func getThinhList() {
        //GET ALL THINH HERE:

        //////////////
        //users += User.mock2()
    }
    func loadUserToView()  {
        //UserImage.setImageWith(URL(string: users[0].avatar!)!)
        //UserImage2.setImageWith(URL(string: users[1].avatar!)!)
        //UserImage3.setImageWith(URL(string: users[2].avatar!)!)
        //UserImage4.setImageWith(URL(string: users[3].avatar!)!)
        //UserImage5.setImageWith(URL(string: users[4].avatar!)!)
        //UserImage6.setImageWith(URL(string: users[5].avatar!)!)
    }
    func initView() {
        for image in [UserImage,UserImage2,UserImage3,UserImage4,UserImage5,UserImage6] {
            image?.layer.cornerRadius = (image?.frame.height)!/2 //set corner for image here
            image?.clipsToBounds = true
        }
        getThinhList()
        loadUserToView()
    }
}













