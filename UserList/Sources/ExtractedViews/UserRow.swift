//
//  UserRow.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct UserRow: View {
    @ObservedObject var viewModel : UserListViewModel
    
    let user : User
    
    var body: some View {
        NavigationLink(destination: UserDetailView(viewModel: viewModel, user: user)) {
            HStack {
                AsyncUserImage(user: user, size: .thumbnail)
                NameAndDobRowText(viewModel: viewModel ,user: user)
            }
        }
    }
}
