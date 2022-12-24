//
//  EmployeeList.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import Foundation

/// A struct describing a list of employees.
struct EmployeeList: Codable {
    /// The list of employee instances contained in the list.
    let employees: [Employee]
}
