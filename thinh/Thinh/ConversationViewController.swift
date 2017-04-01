//
//  ConversationViewController.swift
//  Thinh
//
//  Created by Viet Dang Ba on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import DZNEmptyDataSet

class ConversationViewController: UIViewController {

    @IBOutlet weak var conversationTable: UITableView!
    var conversationList = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        conversationTable.delegate = self
        conversationTable.dataSource = self
        
        conversationTable.emptyDataSetSource = self
        conversationTable.emptyDataSetDelegate = self
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        conversationTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            Api.shared().getAllConversation().subscribe(onNext: { (conversations) in
                self?.conversationList = conversations
                
                for conversation in (self?.conversationList)! {
                    conversation.delegate = self
                }

                self?.conversationList = (self?.conversationList.sorted(by: { $0.lastTime > $1.lastTime }))!
                self?.conversationTable.reloadData()
                self?.conversationTable.dg_stopLoading()
                
            }, onError: { (error) in
                self?.conversationTable.dg_stopLoading()
            }, onCompleted: {
                self?.conversationTable.dg_stopLoading()
            }, onDisposed: nil)
        
            }, loadingView: loadingView)
        conversationTable.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        conversationTable.dg_setPullToRefreshBackgroundColor(conversationTable.backgroundColor!)
        
        let disposable = Api.shared().getAllConversation().subscribe(onNext: { conversations in
            self.conversationList = conversations
            
            for conversation in (self.conversationList) {
                conversation.delegate = self
            }
            self.conversationList = (self.conversationList.sorted(by: { $0.lastTime > $1.lastTime }))
            self.conversationTable.reloadData()
        })
    }
    
    deinit {
        self.conversationTable.dg_removePullToRefresh()
    }

 
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = conversationTable.dequeueReusableCell(withIdentifier: "conversationCell") as! ConversationViewCell
        cell.conversation = conversationList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! UINavigationController
        let chatVC = controller.viewControllers.first as! ChatViewController
        
        chatVC.conversation = self.conversationList[indexPath.row]
        
        self.conversationTable.deselectRow(at: indexPath, animated: false)
        
        self.present(controller, animated: true, completion: nil)
    }

}

extension ConversationViewController: ConversationDelegate{
    func ConversationInfoUpdate(_ conversation: Conversation) {
        self.conversationTable.reloadData()
    }
}

extension ConversationViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "NO MESSAGE"
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 25),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "GETTING NO MESSAGE IS ALSO A MESSAGE"
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Start Tha Thinh !"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: view.tintColor
        ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
        
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        print("Tapped")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.gray
    }

}
