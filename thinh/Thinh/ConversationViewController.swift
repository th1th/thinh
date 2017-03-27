//
//  ConversationViewController.swift
//  Thinh
//
//  Created by Viet Dang Ba on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ConversationViewController: UIViewController {

    @IBOutlet weak var conversationTable: UITableView!
    var conversationList = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        conversationTable.delegate = self
        conversationTable.dataSource = self
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        conversationTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            Api.shared().getAllConversation().subscribe(onNext: { (conversations) in
                self?.conversationList = conversations
                
                for conversation in (self?.conversationList)! {
                    conversation.delegate = self
                }
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
        
        self.present(controller, animated: true, completion: nil)
    }

}

extension ConversationViewController: ConversationDelegate{
    func ConversationInfoUpdate(_ conversation: Conversation) {
        self.conversationTable.reloadData()
    }
}
