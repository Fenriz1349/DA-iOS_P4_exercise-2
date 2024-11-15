//
//  NameAndDobLine.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct NameAndDobRowText: View {
    let user : User
    let isFrench : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(user.name.first) \(user.name.last)")
                .font(.headline)
            Text("\(user.dateOfBirthString(isFrench))")
                .font(.subheadline)
        }
    }
}

#Preview {
    NameAndDobRowText(user: UserListViewModel.userPreview, isFrench: true)
}
