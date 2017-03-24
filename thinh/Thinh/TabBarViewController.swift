//
//  TabBarViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/24/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet var buttons: [UIButton]!
    
    
    var homeViewController: UIViewController!
    var conversationViewController: UIViewController!
    var thaThinhViewController: UIViewController!
    var thinhListViewController: UIViewController!
    var userViewController: UIViewController!
    //an array to hold the ViewControllers named
    var viewControllers: [UIViewController]!
    //keep track of the tab button that is selected
    var selectedIndex: Int = 0

    
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

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        //instantiate each ViewController by referencing storyboard and the particular ViewController's Storyboard ID
        homeViewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController")
        
        
        conversationViewController = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "ConversationViewController")
        
        
        thaThinhViewController = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController")
        
        
        thinhListViewController = UIStoryboard(name: "ThinhList", bundle: nil).instantiateViewController(withIdentifier: "ThinhListViewController")
        
        userViewController = UIStoryboard(name: "UserDetail", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController")
        
        viewControllers = [homeViewController, conversationViewController, thaThinhViewController,thinhListViewController, userViewController]

        //Set the Initial Tab when the App Starts.
        buttons[selectedIndex].isSelected = true
        onClickTab(buttons[selectedIndex])
        
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
