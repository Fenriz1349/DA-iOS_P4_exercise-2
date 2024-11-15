//
//  UserListApp.swift
//  UserList
//
//  Created by Bertrand Bloc'h on 29/09/2023.
//

import SwiftUI

@main
struct UserListApp: App {
    @StateObject var viewModel = UserListViewModel(repository: UserListRepository())
    
    var body: some Scene {
        WindowGroup {
            UserListView(viewModel: viewModel)
        }
    }
}
