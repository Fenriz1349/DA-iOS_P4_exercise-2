//
//  ErrorLabel.swift
//  UserList
//
//  Created by Julien Cotte on 08/11/2024.
//

import SwiftUI

// Affiche un message sur fond rouge
struct ErrorLabel: View {
    var message : String
    
    var body: some View {
            Text("⚠ \(message)")
                .padding(5)
                .foregroundStyle(.white)
                .background(Color.red)
                .cornerRadius(10)
    }
}

#Preview {
    ErrorLabel(message: "Je suis un message d'erreur")
}
