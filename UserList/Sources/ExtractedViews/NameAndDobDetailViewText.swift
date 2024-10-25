//
//  NameAndDobDetailViewText.swift
//  UserList
//
//  Created by Julien Cotte on 25/10/2024.
//

import SwiftUI

import SwiftUI

struct NameAndDobDetailViewText: View {
    @ObservedObject var viewModel : UserListViewModel
    
    let user : User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.getCivility(for: user)) \(user.name.first) \(user.name.last)")
                .font(.headline)
            Text(viewModel.bornOnString(for: user))
                .font(.subheadline)
            Text("\(viewModel.dateOfBirthString(for: user))")
                .font(.subheadline)
        }
    }
}
