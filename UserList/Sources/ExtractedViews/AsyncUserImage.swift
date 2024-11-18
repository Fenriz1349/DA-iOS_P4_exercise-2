//
//  AsyncImage.swift
//  UserList
//
//  Created by Julien Cotte on 24/10/2024.
//

import SwiftUI

// Permet d'afficher l'avatar d'un User au format choisi, soit en utilisant celle des assets, soit celle qui est récupéré sur Internet.
struct AsyncUserImage: View {
    let user : User
    let size : ImageSize
    
    var imageUrl: String {
            switch size {
            case .thumbnail:
                return user.picture.thumbnail
            case .medium:
                return user.picture.medium
            case .large:
                return user.picture.large
            }
        }
    
    var body: some View {
            // Vérifier si l'image provient des assets (nom de l'image local)
            if let _ = UIImage(named: imageUrl) {
                Image(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.rawValue, height: size.rawValue)
                    .clipShape(Circle())
            } else {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.rawValue, height: size.rawValue)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: size.rawValue, height: size.rawValue)
                        .clipShape(Circle())
                }
            }
        }
}
