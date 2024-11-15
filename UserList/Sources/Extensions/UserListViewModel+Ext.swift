//
//  UserListViewModel+Ext.swift
//  UserList
//
//  Created by Julien Cotte on 25/10/2024.
//

import Foundation

extension UserListViewModel {
    
    static var previewViewModel: UserListViewModel {
        let mockRepository = UserListRepository()
        let viewModel = UserListViewModel(repository: mockRepository)
        
        Task {
            await viewModel.fetchUsers()
        }
        
        return viewModel
    }
    
    static let userListResponsePreview = UserListResponse(
           results: [
               UserListResponse.User(
                   name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
                   dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
                   picture: UserListResponse.User.Picture(
                       large: "guts",
                       medium: "guts",
                       thumbnail: "guts"
                   )
               ),
               UserListResponse.User(
                   name: UserListResponse.User.Name(title: "Mme", first: "Jane", last: "Smith"),
                   dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
                   picture: UserListResponse.User.Picture(
                       large: "guts",
                       medium: "guts",
                       thumbnail: "guts"
                   )
               )
           ]
       )
        
    static let userPreview = User(user: userListResponsePreview.results.first!)
    static let userPreviewLady = User(user: userListResponsePreview.results.last!)
    
    var navigationTitle : String {
        isFrench ? "Utilisateurs" : "Users"
    }    
}
