//
//  ChatScreenVC.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 01/05/25.
//

import UIKit
import Combine

class ChatScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = ChatViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupCollectionView()
        searchBar.searchTextField.font = .systemFont(ofSize: 14)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        viewModel.$messages
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionViewHeightConstraint.constant = ((self?.viewModel.pinnedMessages.count ?? 0) > 0 ? 50 : 0)
                self?.tableView.reloadData()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MessageTVCell", bundle: nil), forCellReuseIdentifier: "MessageTVCell")
        self.tableView.register(UINib(nibName: "OtherUserMessageTVCell", bundle: nil), forCellReuseIdentifier: "OtherUserMessageTVCell")
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PinnedMessageCVCell", bundle: nil), forCellWithReuseIdentifier: "PinnedMessageCVCell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            print("Long press at row \(indexPath.row)")
            let message = viewModel.messages[indexPath.item]
            UIView.transition(with: collectionView,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: {
                self.viewModel.togglePin(for: message)
            }, completion: nil)
        }
    }

}

extension ChatScreenVC: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 5 != 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserMessageTVCell", for: indexPath) as? OtherUserMessageTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(message: self.viewModel.messages[indexPath.row].content)
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTVCell", for: indexPath) as? MessageTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(message: self.viewModel.messages[indexPath.row].content)
        cell.selectionStyle = .none
        return cell
    }
}

extension ChatScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pinnedMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinnedMessageCVCell", for: indexPath) as? PinnedMessageCVCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(msg: self.viewModel.pinnedMessages[indexPath.row].content)
        return cell
    }
}

extension ChatScreenVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchedText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.viewModel.searchedText = ""
        searchBar.resignFirstResponder()
    }
}
