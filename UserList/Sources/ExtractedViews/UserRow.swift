//
//  UserRow.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct UserRow: View {
    let user : User
    var body: some View {
        NavigationLink(destination: UserDetailView(user: user)) {
            HStack {
                AsyncUserImage(user: user, size: .thumbnail)
                FirstLastNameAndDobText(user: user)
            }
        }
    }
}
