//
//  ViewController.swift
//  employee-list
//
//  Created by Ivan Konov on 12/22/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        EmployeeListService.getEmployeeList(from: .empty) { result in
            switch result {
            case .success(let employees):
                print(employees)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

