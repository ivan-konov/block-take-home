//
//  EmployeeListSection.swift
//  employee-list
//
//  Created by Ivan Konov on 12/25/22.
//

import Foundation

/// A section displaying a list of employees in a table or collection view.
final class EmployeeListSection {
    /// The unique id.
    var id = UUID()
    /// The employee list displyaed by the section.
    var employees: [Employee]
    
    /// Initializes a section with the provided employees.
    /// - Parameter employees: The list of employees ot be displayed by the section.
    init(employees: [Employee]) {
        self.employees = employees
    }
}

extension EmployeeListSection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EmployeeListSection, rhs: EmployeeListSection) -> Bool {
        lhs.id == rhs.id
    }
}
