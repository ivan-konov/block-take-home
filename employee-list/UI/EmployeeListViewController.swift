//
//  EmployeeListViewController.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import UIKit

class Section: Hashable {
  var id = UUID()
  var employees: [Employee]
  
  init(employees: [Employee]) {
      self.employees = employees
  }
    
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Section, rhs: Section) -> Bool {
    lhs.id == rhs.id
  }
}

final class EmployeeListViewController: UIViewController {
    private typealias DataSource =  UITableViewDiffableDataSource<Section, Employee>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Employee>
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: self.employeeListView) { tableView, indexPath, employee in
            let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.reuseIdentifier, for: indexPath) as? EmployeeCell
            cell?.configure(with: employee)
            return cell
        }
        
        return dataSource
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshEmployeeListData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var employeeListView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.0
        tableView.delegate = self
        tableView.refreshControl = self.refreshControl
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupNavigationBar()
        self.setupEmployeeListView()
        self.refreshEmployeeListData()
    }
    
    // MARK: - Data Loading And Display
    
    @objc
    private func refreshEmployeeListData() {
        EmployeeListService.getEmployeeList(from: .proper) { [weak self] result in
            guard let this = self else {
                return
            }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let employees):
                    this.applySnaphot(with: employees)
                    this.refreshControl.endRefreshing()
                case .failure(let error):
                    // TODO: Show Error UI
                    break
                }
            }
        }
    }
    
    private func applySnaphot(with employees: [Employee]) {
        let section = Section(employees: employees)
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(section.employees)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Utilities
    
    private func setupLayout() {
        self.view.addSubview(self.employeeListView)
        NSLayoutConstraint.activate([
            self.employeeListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.employeeListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.employeeListView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.employeeListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = NSLocalizedString("Employees", comment: "Employee list navigation title")
    }
    
    private func setupEmployeeListView() {
        self.employeeListView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.reuseIdentifier)
    }
}

extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EmployeeCell else { return }
        
        cell.initatePhotoLoad()
    }
}
