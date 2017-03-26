//
//  ConversationViewController.swift
//  Thinh
//
//  Created by Viet Dang Ba on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var conversationTable: UITableView!
    var conversationList = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        conversationTable.delegate = self
        conversationTable.dataSource = self
        
        let disposable = Api.shared().getAllConversation().subscribe(onNext: { conversations in
            self.conversationList = conversations
            
            for conversation in self.conversationList {
                conversation.delegate = self
            }
            self.conversationTable.reloadData()
        })
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
