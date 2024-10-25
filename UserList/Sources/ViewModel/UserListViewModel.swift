//
//  UserListViewModel.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

final class UserListViewModel: ObservableObject {
    // Repository qui recupère toutes données de l'URLRequest
    private let repository : UserListRepository
    
    // var published pour pouvoir mettre la view à jour
    @Published var users : [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    @Published var isFrench = false
    
    // on ne peut init que le repository car les URLRequest sont async et donc non géré dans une init
    init(repository: UserListRepository) {
        self.repository = repository
    }
    
    // fonction qui va géré l'async pour peupler la userList dans la view
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                // Le DispatchQueue force les modification des published var sur le main thread
                DispatchQueue.main.async {
                                self.users.append(contentsOf: users)
                                self.isLoading = false
                            }
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    // fonction pour regarder si on peut continuer à charger des nouveaux utilisateurs
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
