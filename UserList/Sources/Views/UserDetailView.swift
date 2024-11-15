import SwiftUI

struct UserDetailView: View {
    let user: User
    let isFrench: Bool
    
    var body: some View {
        VStack {
            AsyncUserImage(user: user, size:.large)
            NameAndDobDetailViewText(user: user, isFrench: isFrench)
            .padding()
            
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
