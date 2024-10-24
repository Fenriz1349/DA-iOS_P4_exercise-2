//
//  UserCell.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct UserCell: View {
    let user : User
    var body: some View {
        NavigationLink(destination: UserDetailView(user: user)) {
            VStack {
                AsyncUserImage(user: user, size: .medium)
                FirstAndLastNameText(user: user)
            }
        }
    }
}
