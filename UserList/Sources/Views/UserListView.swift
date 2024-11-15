import SwiftUI

struct UserListView: View {

    let viewModel : UserListViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                if !viewModel.isGridView {
                    List(viewModel.users) { user in
                        UserRow(user: user, isFrench: viewModel.isFrench)
                            .onAppear {
                                if viewModel.shouldLoadMoreData(currentItem: user) {
                                    Task {
                                        await viewModel.fetchUsers()
                                    }
                                }
                            }
                    }
                    .customNavigationBar(for: viewModel)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                            ForEach(viewModel.users) { user in
                                UserCell(user: user,isFrench: viewModel.isFrench)
                                    .onAppear {
                                        if viewModel.shouldLoadMoreData(currentItem: user) {
                                            Task {
                                                await viewModel.fetchUsers()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .customNavigationBar(for: viewModel)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
            }
            if viewModel.showError,
            let message = viewModel.errorMessage {
                VStack {
                    HStack {
                        Spacer()
                        ErrorLabel(message: message)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, -45)
                            .padding(.trailing, 15)
                            .task {
                                // Affiche le label pendant 5 secondes puis réinstalle la variable à false
                                try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
                                viewModel.hideErrorMessage()
                            }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: UserListViewModel.previewViewModel)
    }
}
