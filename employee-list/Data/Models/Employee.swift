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
//    //let photos: Photos?
    /// The employee's team.
    let team: String
    /// The employee's type.
    let type: EmployeeType
}

extension Employee: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case team
        case type = "employee_type"
    }
}
