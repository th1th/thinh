//
//  SettingViewController.swift
//  Thinh
//
//  Created by Linh Le on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    var grayBackgroundView = UIView()
    var popupView:PopupView?
    var popupViewDic:[String:PopupView] = [:]
    
    var constX:NSLayoutConstraint?
    var constY:NSLayoutConstraint?
    
    
    @IBAction func showPopUp(_ sender: UIButton) {
        self.showPopupView()
    }
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Done(_ sender: UIButton) {
    }
    
    @IBAction func close(_ sender: UIButton) {
    
        hidePopupView()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
//setting pop up view
extension SettingViewController{
    
    
    func showPopupView(){
        
        //Show GrayView Behind popup view
        self.showGrayBGView(viewController: self, grayView: grayBackgroundView)
        
        //Load nib, and get reference to variable 'popupView'.
        popupView = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)?[0] as? PopupView
        
        self.view.addSubview(popupView!)
        
        //Configure popupview
        popupView?.frame.size = CGSize(width: 0, height: 0)
        popupView?.center = self.view.center
        popupView?.alpha = 0.5
        popupView?.clipsToBounds = true
        popupView?.layer.cornerRadius = 20
        
        
        //Autolayout part
        popupViewDic["popupView"] = popupView
        
        var dView:[String:UIView] = [:]
        dView["popupView"] = popupView
        
        popupView?.translatesAutoresizingMaskIntoConstraints = false
        
        let h_Pin = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[popupView]-(12)-|", options: .alignAllTop, metrics: nil, views: dView)
        self.view.addConstraints(h_Pin)
        let v_Pin = NSLayoutConstraint.constraints(withVisualFormat:"V:|-(36)-[popupView]-(36)-|", options: .alignAllTop, metrics: nil, views: dView)
        self.view.addConstraints(v_Pin)
        
        constY = NSLayoutConstraint(item: popupView!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constY!)
        
        
        constX = NSLayoutConstraint(item: popupView!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constX!)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.50, options: UIViewAnimationOptions.layoutSubviews, animations: { () -> Void in
            self.popupView?.alpha = 1
            self.view.layoutIfNeeded()
        }) { (value:Bool) -> Void in
            
        }
        
    }
    
    
    //Gray bg view configuration
    func showGrayBGView(viewController:UIViewController,grayView:UIView){
        
        var viewController:UIViewController = viewController
        var GrayView:UIView = grayView
        
        viewController.view.addSubview(GrayView)
        
        var dView:[String:UIView] = [:]
        dView["GrayView"] = GrayView
        
        GrayView.frame = viewController.view.frame
        GrayView.backgroundColor = UIColor.clear
        GrayView.translatesAutoresizingMaskIntoConstraints = (false)
        UIView.animate(withDuration: 0.5, animations: {
            GrayView.backgroundColor = UIColor.black
            GrayView.alpha = 0.75
        })
        
        var h_Pin = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-16)-[GrayView]-(-16)-|", options: .alignAllTop, metrics: nil, views: dView)
        viewController.view.addConstraints(h_Pin)
        
        var v_Pin = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-16)-[GrayView]-(-16)-|", options: .alignAllTop, metrics: nil, views: dView)
        viewController.view.addConstraints(v_Pin)
        
    }
    
    func hidePopupView(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.50, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            self.grayBackgroundView.alpha = 0
            self.popupView!.alpha = 0
            
        }) { (value:Bool) -> Void in
            self.popupView!.removeFromSuperview()
            self.grayBackgroundView.removeFromSuperview()
            
        }
        
    }
}
