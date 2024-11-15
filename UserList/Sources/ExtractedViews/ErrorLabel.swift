//
//  ErrorLabel.swift
//  UserList
//
//  Created by Julien Cotte on 08/11/2024.
//

import SwiftUI

struct ErrorLabel: View {
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        if viewModel.showError, let errorMessage = viewModel.errorMessage {
            Text("⚠ \(errorMessage)")
                .padding(5)
                .foregroundStyle(.white)
                .background(Color.red)
                .cornerRadius(10)
                .transition(.move(edge: .top).combined(with: .opacity))
                .task {
                    // Affiche le label pendant 5 secondes puis réinstalle la variable à false
                    try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
                    viewModel.showError = false
                    viewModel.errorMessage = nil
                }
        }
    }
}

#Preview {
    ErrorLabel(viewModel: UserListViewModel.previewViewModel)
}
