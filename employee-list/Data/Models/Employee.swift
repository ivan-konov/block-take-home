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
    enum EmployeeType: String {
        /// Full time employee.
        case fullTime
        /// Part time employee.
        case partTime
        /// Contractor employee.
        case contractor
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
