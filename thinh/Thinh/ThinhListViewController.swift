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
    
    
    @IBAction func onClickClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func initView() {
        for image in [UserImage,UserImage2,UserImage3,UserImage4,UserImage5,UserImage6] {
            image?.layer.cornerRadius = (image?.frame.height)!/2 //set corner for image here
            image?.clipsToBounds = true
        }
    }

}
