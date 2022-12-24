//
//  Employee.swift
//  employee-list
//
//  Created by Ivan Konov on 12/22/22.
//

import Foundation

/// A struct describing an employee.
struct Employee {
    /// An enumeration describing the different employee types.
    enum EmployeeType: String, Codable {
        /// Full time employee.
        case fullTime = "FULL_TIME"
        /// Part time employee.
        case partTime = "PART_TIME"
        /// Contractor employee.
        case contractor = "CONTRACTOR"
        
        var displayString: String {
            switch self {
            case .fullTime:
                return NSLocalizedString("Full Time", comment: "Full time Employee Type")
            case .partTime:
                return NSLocalizedString("Part Time", comment: "Part time Employee Type")
            case .contractor:
                return NSLocalizedString("Contractor", comment: "Contractor Employee Type")
            }
        }
    }
    
    /// The employee's ID.
    let id: UUID
    /// The employee's full name.
    let fullName: String
    /// The employee's phone number.
    let phoneNumber: String?
    /// The employee's email address.
    let emailAddress: String
    /// The employee's short biography.
    let biography: String?
    /// The employee's photos for various sizes.
    let photos: Photos?
    /// The employee's team.
    let team: String
    /// The employee's type.
    let type: EmployeeType
}

extension Employee: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(UUID.self, forKey: .id)
        fullName = try values.decode(String.self, forKey: .fullName)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        emailAddress = try values.decode(String.self, forKey: .emailAddress)
        biography = try values.decode(String.self, forKey: .biography)
        
        let smallPhotoURL = try values.decode(URL.self, forKey: .smallPhoto)
        let largePhotoURL = try values.decode(URL.self, forKey: .largePhoto)
        photos = Photos(photoURLs: [.small: smallPhotoURL, .large: largePhotoURL])
        
        team = try values.decode(String.self, forKey: .team)
        type = try values.decode(EmployeeType.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(emailAddress, forKey: .emailAddress)
        try container.encode(biography, forKey: .biography)
        
        if let smallPhotoURL = photos?.photoURL(for: .small) {
            try container.encode(smallPhotoURL, forKey: .smallPhoto)
        }
        if let largePhotoURL = photos?.photoURL(for: .large) {
            try container.encode(largePhotoURL, forKey: .largePhoto)
        }
       
        try container.encode(team, forKey: .team)
        try container.encode(type, forKey: .type)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case smallPhoto = "photo_url_small"
        case largePhoto = "photo_url_large"
        case team
        case type = "employee_type"
    }
}

extension Employee: Hashable {
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
