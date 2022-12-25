//
//  EmployeeListDataProvider.swift
//  employee-list
//
//  Created by Ivan Konov on 12/25/22.
//

import Foundation

/// A provider of `Employee` data from the `EmloyeeService`.
final class EmployeeListDataProvider {
    /// An enumeration dscribing the various provier states.
    enum State {
        /// An error state with an error description.
        case error(String)
        /// A loading state.
        case loading
        /// A state holding employee data.
        case data([Employee])
    }
    
    /// The current state of the provider.
    @Published var state: State = .loading
    
    /// The desiderd endpoint to call the `EmployeeListService` with.
    var endpoint: EmployeeListService.Endpoints = .proper
    
    /// Request employee data from the employee service.
    func getEmployeeList() {
        self.state = .loading
        
        EmployeeListService.getEmployeeList(from: self.endpoint) { [weak self] result in
            guard let this = self else {
                return
            }
            
            switch result {
            case .success(let employees):
                this.state = .data(employees)
            case .failure(let error):
                this.state = .error(error.localizedDescription)
            }
        }
    }
}
