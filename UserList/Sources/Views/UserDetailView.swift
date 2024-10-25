import SwiftUI

struct UserDetailView: View {
    @ObservedObject var viewModel : UserListViewModel
    
    let user: User
    
    var body: some View {
        VStack {
            AsyncUserImage(user: user, size:.large)
            NameAndDobDetailViewText(viewModel: viewModel, user: user)
            .padding()
            
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
