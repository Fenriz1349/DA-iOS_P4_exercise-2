//
//  UserListViewModel+Ext.swift
//  UserList
//
//  Created by Julien Cotte on 25/10/2024.
//

import Foundation

extension UserListViewModel {
    var navigationTitle : String {
        isFrench ? "Utilisateurs" : "Users"
    }
    
    func dateOfBirthString(for user : User) -> String {
        isFrench ? user.dob.getFrenchDate() : user.dob.getUSDate()
    }
    
    func getCivility(for user: User) -> String {
        enum frenchCivilities: String{
            case monsieur = "Monsieur"
            case madame = "Madame"
            case mademoiselle = "Mademoiselle"
        }
        
        enum englishCivilities: String{
            case monsieur = "Mister"
            case madame = "Mrs"
            case mademoiselle = "Miss"
        }
        
        switch user.name.title.lowercased() {
        case "m" :
            return isFrench ? frenchCivilities.monsieur.rawValue : englishCivilities.monsieur.rawValue
        case "monsieur" :
            return isFrench ? frenchCivilities.monsieur.rawValue : englishCivilities.monsieur.rawValue
        case "mr" :
            return isFrench ? frenchCivilities.monsieur.rawValue : englishCivilities.monsieur.rawValue
        case "mister" :
            return isFrench ? frenchCivilities.monsieur.rawValue : englishCivilities.monsieur.rawValue
        case "ms" :
            return isFrench ? frenchCivilities.madame.rawValue : englishCivilities.madame.rawValue
        case "mrs" :
            return isFrench ? frenchCivilities.madame.rawValue : englishCivilities.madame.rawValue
        case "madame" :
            return isFrench ? frenchCivilities.madame.rawValue : englishCivilities.madame.rawValue
        case "miss" :
            return isFrench ? frenchCivilities.mademoiselle.rawValue : englishCivilities.mademoiselle.rawValue
        case "mademoiselle" :
            return isFrench ? frenchCivilities.mademoiselle.rawValue : englishCivilities.mademoiselle.rawValue
        case "mlle" :
            return isFrench ? frenchCivilities.mademoiselle.rawValue : englishCivilities.mademoiselle.rawValue
        default : return user.name.title
        }
    }
    
    func bornOnString(for user: User) -> String {
        !isFrench ? "born on :" : getCivility(for: user) == "Monsieur" ? "né le :" : "née le :"
    }
}
