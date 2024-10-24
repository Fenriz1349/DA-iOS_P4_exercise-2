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
                AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading) {
                    Text("\(user.name.first) \(user.name.last)")
                        .font(.headline)
                    Text("\(user.dob.date)")
                        .font(.subheadline)
                }
            }
        }
    }
}
