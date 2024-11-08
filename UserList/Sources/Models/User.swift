import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    let name: Name
    let dob: Dob
    let picture: Picture

    // MARK: - Init
    init(user: UserListResponse.User) {
        self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)
        self.dob = .init(date: user.dob.date, age: user.dob.age)
        self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
    }

    // MARK: - Date of birth
    struct Dob: Codable {
        let date: String
        let age: Int
        
        func getFrenchDate() -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let dateFr = inputFormatter.date(from: date) {
                let outputFormatter = DateFormatter()
                outputFormatter.locale = Locale(identifier: "fr_FR")
                outputFormatter.dateFormat = "d MMMM yyyy"
                
                return outputFormatter.string(from: dateFr)
            } else {
                return date
            }
        }
        
        func getUSDate() -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let dateUs = inputFormatter.date(from: date) {
                let outputFormatter = DateFormatter()
                outputFormatter.locale = Locale(identifier: "en_US")
                outputFormatter.dateFormat = "MMMM d yyyy"
                
                return outputFormatter.string(from: dateUs)
            } else {
                return date
            }
        }
    }

    // MARK: - Name
    struct Name: Codable {
        let title, first, last: String
    }

    // MARK: - Picture
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }
}
