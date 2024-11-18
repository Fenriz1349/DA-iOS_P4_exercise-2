//
//  User+Ext.swift
//  UserList
//
//  Created by Julien Cotte on 15/11/2024.
//

import Foundation
 
extension User {
    // Permet de retourner la date de naissance d'un User au format français ou américain
    func dateOfBirthString(_ isFrench : Bool) -> String {
        isFrench ? self.dob.getFrenchDate() : self.dob.getUSDate()
    }
    
    // Permet de retourner la civité suivant la langue choisie
    func getCivility(_ isFrench: Bool) -> String {
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
        
        switch self.name.title.lowercased() {
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
        default : return self.name.title
        }
    }
    
    
    func bornOnString(_ isFrench : Bool) -> String {
        !isFrench ? "born on :" : self.getCivility(isFrench) == "Monsieur" ? "né le :" : "née le :"
    }
    
}
