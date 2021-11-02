//
//  SocketService.swift
//  SocketIO-RealTime
//
//  Created by Windy on 31/10/21.
//

import SocketIO
import CoreFoundation

protocol ChatServiceDelegate: AnyObject {
    func didGetMessage(message: MessageModel)
    func didGetTotalUser(total: Int)
}

protocol ChatServiceProtocol {
    func removeConnection()
    func observeMessage()
    func observeTotalUser()
    func sendMessage(message: String)
}

class ChatService: ChatServiceProtocol {
    
    private let id: String = UUID().uuidString
    private var socketClient: SocketIOClient
    
    private let socketManager = SocketManager(socketURL: URL(string: "ENTER YOUR URL HERE")!)
    
    weak var delegate: ChatServiceDelegate?
    
    init() {
        self.socketClient = socketManager.defaultSocket
        self.socketClient.connect()
    }
    
    func sendMessage(message: String) {
        socketClient.emit("chatMessage", [
            "id": id,
            "message": message])
    }
    
    func observeMessage() {
        socketClient.on("chatMessage") { [weak self] data, ack in
            let data = data[0] as! Dictionary<String, Any>
            let messageModel = MessageModel(
                message: data["message"]! as! String,
                isSender: data["id"]! as? String == self?.id)
            self?.delegate?.didGetMessage(message: messageModel)
        }
    }
    
    func observeTotalUser() {
        socketClient.on("totalUser") { [weak self] data, ack in
            let message = data[0] as! Int
            self?.delegate?.didGetTotalUser(total: message)
        }
    }
    
    func removeConnection() {
        socketClient.disconnect()
    }
    
}
