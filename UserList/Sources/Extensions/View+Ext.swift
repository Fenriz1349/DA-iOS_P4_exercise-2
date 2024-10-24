//
//  View+Ext.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

extension View {
    func customNavigationBar(for viewModel: UserListViewModel) -> some View {
        self.modifier(CustomNavigationBarModifier(viewModel: viewModel))
    }
}
