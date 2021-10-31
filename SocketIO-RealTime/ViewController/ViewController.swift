//
//  ViewController.swift
//  SocketIO-RealTime
//
//  Created by Windy on 29/10/21.
//

import UIKit

class ViewController: UIViewController {

    private var socketService: ChatService!
    
    convenience init(chatService: ChatService) {
        self.init(nibName: nil, bundle: nil)
        
        self.socketService = chatService
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private var messages: [MessageModel] = []

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        socketService.removeConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        socketService.observeMessage()
        socketService.observeTotalUser()
        socketService.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier) as! MessageTableViewCell
        cell.configureCell(message: messages[indexPath.row])
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return messages.count
    }
    
}

extension ViewController: ChatServiceDelegate {
    
    func didGetTotalUser(total: Int) {
        navigationItem.title = "\(total) online"
    }
    
    func didGetMessage(message: MessageModel) {
        messages.append(message)
        tableView.reloadData()
                
        tableView.scrollToRow(
            at: IndexPath(row: messages.count - 1, section: 0),
            at: .bottom,
            animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = textField.text, !message.isEmpty else { return true }
        socketService.sendMessage(message: message)
        textField.text?.removeAll()
        return true
    }
    
}
