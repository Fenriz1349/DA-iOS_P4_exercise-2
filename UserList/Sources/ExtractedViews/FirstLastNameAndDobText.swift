//
//  NameAndDobLine.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct FirstLastNameAndDobText: View {
    let user : User
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(user.name.first) \(user.name.last)")
                .font(.headline)
            Text("\(user.dob.date)")
                .font(.subheadline)
        }
    }
}

