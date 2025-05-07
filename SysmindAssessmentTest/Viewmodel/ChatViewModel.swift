//
//  ChatViewModel.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 03/05/25.
//

import Foundation
import Combine
import RealmSwift


class ChatViewModel {
    @Published var messages: [Message] = []
    @Published var pinnedMessages: [Message] = []
    @Published var searchedText: String = ""
    private var allMessages: [Message] = []

    private var cancellables = Set<AnyCancellable>()
    private var localDBManager: LocalDBManager

    init() {
        self.localDBManager = LocalDBManager()
        self.allMessages = self.localDBManager.fetchAllMessagesFromLocalDB()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fetchMessages()
        }
        self.handleSearching()
    }
    
    
    func handleSearching() {
        $searchedText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                if text == "" {
                    self.messages = self.allMessages
                    self.pinnedMessages = self.messages.filter { $0.isPinned }
                } else {
                    self.messages = self.allMessages.filter({$0.content.lowercased().contains(text.lowercased()) || $0.sender.lowercased().contains(text.lowercased())})
                    self.pinnedMessages = self.messages.filter { $0.isPinned }
                }
            }
            .store(in: &cancellables)
    }
    
    

    func fetchMessages() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .print("Debugging")
            .map(\.data)
            .decode(type: [APIMessage].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { output in
                self.localDBManager.saveMessagesToLocalDB(output)
                DispatchQueue.main.async { [weak self] in
                    self?.allMessages = self?.localDBManager.fetchAllMessagesFromLocalDB() ?? []
                    self?.messages = self?.allMessages ?? []
                    self?.pinnedMessages = self?.messages.filter { $0.isPinned } ?? []
                }
            })
            .store(in: &cancellables)
    }

    func togglePin(for message: Message) {
        guard let index = messages.firstIndex(of: message) else { return }
        messages[index].isPinned.toggle()
        self.pinnedMessages = messages.filter { $0.isPinned }
        self.localDBManager.updateMessageState(for: messages[index])
        self.allMessages = self.localDBManager.fetchAllMessagesFromLocalDB()
    }
}
