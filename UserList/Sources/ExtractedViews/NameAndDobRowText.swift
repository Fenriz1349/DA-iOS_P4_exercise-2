//
//  NameAndDobLine.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct NameAndDobRowText: View {
    @ObservedObject var viewModel : UserListViewModel
    
    let user : User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(user.name.first) \(user.name.last)")
                .font(.headline)
            Text("\(viewModel.dateOfBirthString(for: user))")
                .font(.subheadline)
        }
    }
}
