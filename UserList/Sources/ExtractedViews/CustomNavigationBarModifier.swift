//
//  NavigationBar.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

struct CustomNavigationBarModifier: ViewModifier {
    @ObservedObject var viewModel : UserListViewModel
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Picker(selection: $viewModel.isFrench, label: Text("Display")) {
                        Text("🇫🇷")
                            .tag(true)
                            .accessibilityLabel(Text("French"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Text("🇺🇸")
                            .tag(false)
                            .accessibilityLabel(Text("List view"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                        Image(systemName: "rectangle.grid.1x2.fill")
                            .tag(true)
                            .accessibilityLabel(Text("English"))
                        Image(systemName: "list.bullet")
                            .tag(false)
                            .accessibilityLabel(Text("List view"))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.reloadUsers()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
    }
}

struct CustomNavigationBarModifier_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Text("User List")
                .modifier(CustomNavigationBarModifier(viewModel: previewViewModel))
        }
    }

    static var previewViewModel: UserListViewModel {
        let viewModel = UserListViewModel(repository: UserListRepository())
        viewModel.isFrench = true
        viewModel.isGridView = true
        viewModel.showError = true
        viewModel.errorMessage = "Ceci est un Test"
        return viewModel
    }
}
