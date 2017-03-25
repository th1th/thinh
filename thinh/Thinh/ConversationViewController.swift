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
        
        let disposable = Api.shared().getAllConversation().subscribe(onNext: { (conversations) in
            self.conversationList = conversations
            self.conversationTable.reloadData()
        })
        disposable.dispose()
        
        let fakeConversation1 = Conversation(message: "Alo Alo 1234", time: 1490325105.0, name: "Dat Tran", avatar: "https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/15622573_1085371901571808_5746077286281389946_n.jpg?oh=a4940622ada3ec2e2a47d5040158e464&oe=5972472E", online: true)
        let fakeConversation2 = Conversation(message: "Alo Alo 4321", time: 1490325111.0, name: "Linh Le", avatar: "https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/15622573_1085371901571808_5746077286281389946_n.jpg?oh=a4940622ada3ec2e2a47d5040158e464&oe=5972472E", online: false)
        conversationList.append(contentsOf: [fakeConversation1, fakeConversation2])
        conversationTable.reloadData()
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
