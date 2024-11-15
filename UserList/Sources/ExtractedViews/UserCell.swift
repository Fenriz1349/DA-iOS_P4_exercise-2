//
//  UserCell.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct UserCell: View {
    let user : User
    let isFrench: Bool
    var body: some View {
        NavigationLink(destination: UserDetailView(user: user, isFrench: isFrench)) {
            VStack {
                AsyncUserImage(user: user, size: .medium)
                FirstAndLastNameText(user: user)
            }
        }
    }
}

#Preview {
    UserCell(user: UserListViewModel.userPreview, isFrench: true)
}
