//
//  EmployeeListService.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import Foundation

/// A service returning employee list data.
enum EmployeeListService {
    private struct Strings {
        static let malformedListErrorDescription = NSLocalizedString("The employee list returned from the service was malformed.",
                                                                     comment: "An error description for a malformed employee list data returned from the server.")
        static let emptyListErrorDescription = NSLocalizedString("The employee list returned from the service was empty.",
                                                                 comment: "An error description for an empty employee list data returned from the server.")
        static let invalidURLErrorDescription = NSLocalizedString("The employee service was called with an invalid URL.",
                                                  comment: "An error description for an invalid URL used when requesting employee list data returned from the server.")
        static let serverProvidedErrorDescriptionFormat = NSLocalizedString("The employee service returned an error: %@",
                                                                 comment: "An error description format for an error returned from the server.")
        static let properEndpointTitle = NSLocalizedString("Proper Format Format", comment: "A title for a service endpoint providing properly formatted data to be displayed in UI.")
        static let malformedEndpointTitle = NSLocalizedString("Malformed List", comment: "A title for a service endpoint providing a malformed list of data to be displayed in UI.")
        static let emptyEndpointTitle = NSLocalizedString("Empty List", comment: "A title for a service endpoint providing an empty list to be displayed in UI.")
    }
    
    typealias EmployeeListServiceResult = Result<[Employee], EmployeeListServiceError>
    typealias EmployeeListServiceCompletion = (EmployeeListServiceResult) -> Void
    
    /// A list of errors the `EmployeeService` could produce.
    enum EmployeeListServiceError: Error {
        /// Malformed list error.
        case malformedList
        /// Empty list error.
        case emptyList
        /// Invalid request URL error.
        case invalidURL
        /// Server provided error.
        case serverProvidedError(String)
        
        /// Human readable description of the error.
        var localizedDescription: String {
            switch self {
            case .malformedList:
                return Strings.malformedListErrorDescription
            case .emptyList:
                return Strings.emptyListErrorDescription
            case .invalidURL:
                return Strings.invalidURLErrorDescription
            case .serverProvidedError(let errorDescription):
                return String.localizedStringWithFormat(Strings.serverProvidedErrorDescriptionFormat, errorDescription)
            }
        }
    }

    /// Endpoints of the employees service.
    enum Endpoints: CaseIterable {
        /// An endpoint returning a properly formatted employee list.
        case proper
        /// An endpoint returning a malformed employee list.
        case malformed
        /// An endpoint returning an empty employee list.
        case empty
        
        /// The `URL` of the endpoint.
        var url: URL? {
            switch self {
            case .proper:
                return URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")
            case .malformed:
                return URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json")
            case .empty:
                return URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json")
            }
        }
        
        /// A title for the endpoint to be displayed in UI elements.
        var displayTitle: String {
            switch self {
            case .proper:
                return Strings.properEndpointTitle
            case .malformed:
                return Strings.malformedEndpointTitle
            case .empty:
                return Strings.emptyEndpointTitle
            }
        }
    }
    
    // MARK: - Public API
    
    /// A method calling an endpoint of the employee list service.
    /// - Parameters:
    ///   - endpoint: The desired endpoint to call.
    ///   - completion: A closure containing the result of the API call - either a list of employees or an error instance.
    static func getEmployeeList(from endpoint: Endpoints, completion: @escaping EmployeeListServiceCompletion) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.serverProvidedError(error.localizedDescription)))
                return
            }

            completion(EmployeeListService.parse(data: data))
        }.resume()
    }
    
    // MARK: - Utilities
    
    static private func parse(data: Data?) -> EmployeeListServiceResult {
        guard let data = data else {
             return .failure(.emptyList)
        }
        
        let decoder = JSONDecoder()
        guard let employeeList = try? decoder.decode(EmployeeList.self, from: data) else {
            return .failure(.malformedList)
        }

        guard !employeeList.employees.isEmpty else {
            return .failure(.emptyList)
        }

        return .success(employeeList.employees)
    }
}
