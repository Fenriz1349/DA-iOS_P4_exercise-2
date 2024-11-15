//
//  NameAndDobDetailViewText.swift
//  UserList
//
//  Created by Julien Cotte on 25/10/2024.
//

import SwiftUI

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
