import SwiftUI

struct UserListView: View {

    @StateObject var viewModel = UserListViewModel(repository: UserListRepository())
    
    var body: some View {
        NavigationView {
            if !viewModel.isGridView {
                List(viewModel.users) { user in
                    UserRow(viewModel: viewModel, user: user)
                    .onAppear {
                        if viewModel.shouldLoadMoreData(currentItem: user) {
                            viewModel.fetchUsers()
                        }
                    }
                }
                .customNavigationBar(for: viewModel)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(viewModel.users) { user in
                            UserCell(viewModel: viewModel, user: user)
                            .onAppear {
                                if viewModel.shouldLoadMoreData(currentItem: user) {
                                    viewModel.fetchUsers()
                                }
                            }
                        }
                    }
                }
                .customNavigationBar(for: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
