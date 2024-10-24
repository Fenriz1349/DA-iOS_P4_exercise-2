import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            AsyncUserImage(user: user, size:.large)
           FirstLastNameAndDobText(user: user)
            .padding()
            
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
