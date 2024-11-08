//
//  ErrorLabel.swift
//  UserList
//
//  Created by Julien Cotte on 08/11/2024.
//

import SwiftUI

struct ErrorLabel: View {
    let message = "Erreur"
    var body: some View {
        Text("⚠ \(message)")
            .background(.red)
    }
}

#Preview {
    ErrorLabel()
}
