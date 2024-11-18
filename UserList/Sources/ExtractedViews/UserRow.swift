//
//  UserRow.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

// Affichage d'un User en mode Liste
struct UserRow: View {
    let user : User
    let isFrench: Bool
    
    var body: some View {
        NavigationLink(destination: UserDetailView(user: user, isFrench: isFrench)) {
            HStack {
                AsyncUserImage(user: user, size: .thumbnail)
                NameAndDobRowText(user: user,isFrench: isFrench)
            }
        }
    }
}

#Preview {
    UserRow(user: UserListViewModel.userPreview, isFrench: true)
}
