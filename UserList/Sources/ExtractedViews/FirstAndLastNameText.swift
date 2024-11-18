//
//  OnlyName.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

// Affiche le prenom et le nom d'un User
struct FirstAndLastNameText: View {
    let user : User
    
    var body: some View {
        Text("\(user.name.first) \(user.name.last)")
            .font(.headline)
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    FirstAndLastNameText(user: UserListViewModel.userPreview)
}
