//
//  TabBarViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/24/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import NoticeBar
import CoreLocation


class TabBarViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var chatBagde: UILabel!
    @IBOutlet weak var thinhBagde: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    
    var homeViewController: UIViewController!
    var conversationViewNavigator: UIViewController!
    var thaThinhViewController: UIViewController!
    var thinhListViewController: ThinhListViewController!
    var userViewController: UIViewController!
    //an array to hold the ViewControllers named
    var viewControllers: [UIViewController]!
    //keep track of the tab button that is selected
    var selectedIndex: Int = 0
    //count number of new chats
    var chatCount: Int = 0
    var thinhCount: Int = 0
    //location
    var locationManager: CLLocationManager! = CLLocationManager()

    
    @IBAction func onClickTab(_ sender: UIButton) {
        //Get Access to the Previous and Current Tab Button.
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        //Remove the Previous ViewController and Set Button State.
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        //Add the New ViewController and Set Button State.
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)

        //
        updateTabBarImage(selectselectedIndex: selectedIndex, previousIndex: previousIndex)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()

        //instantiate each ViewController by referencing storyboard and the particular ViewController's Storyboard ID
        homeViewController = UIStoryboard(name: "ContactList", bundle: nil).instantiateViewController(withIdentifier: "ContactListViewController")
        
        
        //conversationViewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController")
        conversationViewNavigator = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "Conversation") as! UINavigationController
        let conversationViewController = (conversationViewNavigator as! UINavigationController).topViewController as! ConversationViewController
        conversationViewController.delegate = self
        
        thaThinhViewController = UIStoryboard(name: "ThaThinh", bundle: nil).instantiateViewController(withIdentifier: "ThaThinhViewController")
        
        
        thinhListViewController = UIStoryboard(name: "ThinhList", bundle: nil).instantiateViewController(withIdentifier: "ThinhListViewController") as! ThinhListViewController
        thinhListViewController.delegate = self
        
        
        
        userViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
        
        viewControllers = [homeViewController, conversationViewNavigator, thaThinhViewController,thinhListViewController, userViewController]

        //Set the Initial Tab when the App Starts.
        buttons[selectedIndex].isSelected = true
        onClickTab(buttons[selectedIndex])
        

        //request access user's location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            User.currentUser?.lon = locationManager.location?.coordinate.longitude
            User.currentUser?.lat = locationManager.location?.coordinate.latitude
            utilities.log("\(User.currentUser?.lon)+++\(User.currentUser?.lat)")
            utilities.log("Location services are not enabled")
            utilities.log(locationManager.location?.coordinate)
            locationManager.stopUpdatingLocation()
        }

        
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

//Tab Bar View config
extension TabBarViewController{
    func initView() {
        updateChatCount()
        updateThinhCount()
    }
    func updateChatCount(){
        if chatCount>0 {
            chatBagde.frame = CGRect(x: view.frame.width*1.55/5, y: 0.0, width: 25.0, height: 16.0)
            chatBagde.layer.cornerRadius = 7
            chatBagde.clipsToBounds = true
            chatBagde.text = "\(chatCount)"
        }else{
            chatBagde.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    func updateThinhCount() {
        if thinhCount>0 {
            thinhBagde.frame = CGRect(x: view.frame.width*1.55/2.22, y: 0.0, width: 25.0, height: 16.0)
            thinhBagde.layer.cornerRadius = 7
            thinhBagde.clipsToBounds = true
            thinhBagde.text = "\(thinhCount)"
        }else{
            thinhBagde.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    func updateTabBarImage(selectselectedIndex:Int,previousIndex:Int) {
        switch previousIndex {
        case 0:
            buttons[previousIndex].setImage(UIImage(named: "ContactTabBar"), for: UIControlState.normal)
            break
        case 1:
            buttons[previousIndex].setImage(UIImage(named: "ChatTabBar"), for: UIControlState.normal)
            break
        case 2:
            buttons[previousIndex].setImage(UIImage(named: "ThaTabBar"), for: UIControlState.normal)
            break
        case 3:
            buttons[previousIndex].setImage(UIImage(named: "ThinhTabBar"), for: UIControlState.normal)
            break
        case 4:
            buttons[previousIndex].setImage(UIImage(named: "MeTabBar"), for: UIControlState.normal)
            break
        default: break
        }
        switch selectedIndex {
        case 0:
            buttons[selectedIndex].setImage(UIImage(named: "ContactsSelectedTabBar"), for: UIControlState.normal)
            break
        case 1:
            buttons[selectedIndex].setImage(UIImage(named: "ChatSelectedTabBar"), for: UIControlState.normal)
            break
        case 2:
            buttons[selectedIndex].setImage(UIImage(named: "ThaSelectedTabBar"), for: UIControlState.normal)
            break
        case 3:
            buttons[selectedIndex].setImage(UIImage(named: "ThinhSelectedTabBar"), for: UIControlState.normal)
            break
        case 4:
            buttons[selectedIndex].setImage(UIImage(named: "MeSelectedTabBar"), for: UIControlState.normal)
            break
        default: break
        }
        updateChatCount()
        updateThinhCount()
    }
}

extension TabBarViewController: ConversationViewControllerDelegate, ThinhListViewControllerDelegate {
    
    func numberOfUnseenConversation(_ n: Int){
        chatCount = n
        updateChatCount()
    }
    
    func numberOfStrangerThinh(_ n: Int) {
        thinhCount = n
        updateThinhCount()
    }
    
    func gotNewThinh(_ conversation: Conversation) {
        print("Got thinh")
        
        Api.shared().getUser(id: conversation.partnerID!).subscribe(onNext: { (user) in
            let url = URL(string: user.avatar!)
            let imageView = UIImageView()
            
            imageView.af_setImage(withURL: url!) { (response) in
                
                let image = JSQMessagesAvatarImageFactory.avatarImage(with: response.result.value, diameter: 120).avatarImage
                let config = NoticeBarConfig(title: "#You've matched with \(conversation.partnerName!)", image: image, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.right )
                let noticeBar = NoticeBar(config: config)
                /// do something before noticeBar show.
                /// such as : 
                UIApplication.shared.statusBarStyle = .lightContent
                noticeBar.show(duration: 3.0, completed: {
                    (finished) in
                    if finished {
                        /// do something here.
                        /// such as : 
                        UIApplication.shared.statusBarStyle = .default
                    }
                })
                
            }
        })
        
    }
}
extension TabBarViewController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        print(long, lat)
        
        //Do What ever you want with it
    }
}
