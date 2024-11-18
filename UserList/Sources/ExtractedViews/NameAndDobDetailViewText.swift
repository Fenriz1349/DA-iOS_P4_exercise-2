//
//  NameAndDobDetailViewText.swift
//  UserList
//
//  Created by Julien Cotte on 25/10/2024.
//

import SwiftUI

// Affiche sur une ligne le nom et le prenom d'un User,
// sur une autre "né le :" ou "born on:" suivant la langue,
// Puis la date de naissance au format de la langue.
struct NameAndDobDetailViewText: View {
    let user : User
    let isFrench : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(user.getCivility(isFrench)) \(user.name.first) \(user.name.last)")
                .font(.headline)
            Text(user.bornOnString(isFrench))
                .font(.subheadline)
            Text("\(user.dateOfBirthString(isFrench))")
                .font(.subheadline)
        }
    }
}

#Preview {
    NameAndDobDetailViewText(user: UserListViewModel.userPreview, isFrench: true)
}
