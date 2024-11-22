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
    @Published var showError = false
    @Published var errorMessage : String?
    
    // on ne peut init que le repository car les URLRequest sont async et donc non géré dans une init
    init(repository: UserListRepository) {
        self.repository = repository
    }
    
    // fonction qui va géré l'async pour peupler la userList dans la view
    @MainActor
    func fetchUsers() async {
        isLoading = true
        do {
            let users = try await repository.fetchUsers(quantity: 20)
            self.users.append(contentsOf: users)
            self.isLoading = false
        } catch {
            setErrorMessage("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    // fonction pour configurer le message d'erreur et l'afficher
    func setErrorMessage(_ message: String) {
        errorMessage = message
        showError = true        
    }
    
    func hideErrorMessage() {
        errorMessage = nil
        showError = false
    }
    
    // fonction pour regarder si on peut continuer à charger des nouveaux utilisateurs
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    @MainActor
    func reloadUsers() async {
        users.removeAll()
        await fetchUsers()
    }
}
