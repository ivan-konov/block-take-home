//
//  EmployeeListViewController.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import UIKit
import Combine

final class EmployeeListViewController: UIViewController {
    private struct Strings {
        static let loadingLabelTitle = NSLocalizedString("Loading...", comment: "A label indicating a loading state of en employee list UI.")
        static let navigationTitle = NSLocalizedString("Employees", comment: "Employee list navigation title")
    }
    
    private typealias DataSource =  UITableViewDiffableDataSource<EmployeeListSection, Employee>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<EmployeeListSection, Employee>
    
    private var stateSubscriber: AnyCancellable?
    private let dataProvider = EmployeeListDataProvider()
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: self.employeeListView) { tableView, indexPath, employee in
            let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.reuseIdentifier, for: indexPath) as? EmployeeCell
            cell?.configure(with: employee)
            return cell
        }
        
        return dataSource
    }()
    
    // MARK: - UI
    
    private lazy var employeeListView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.0
        tableView.delegate = self
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .callout, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var loadingStateView: UIStackView = {
        let container = UIStackView(arrangedSubviews: [self.loadingIndicator, self.stateLabel])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 10.0
        return container
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setupLayout()
        self.setupNavigationBar()
        self.setupSubscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshEmployeeList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stateSubscriber?.cancel()
    }
    
    // MARK: - Data Loading And Display
    
    @objc
    private func refreshEmployeeList() {
        self.dataProvider.getEmployeeList()
    }
    
    private func setupUI(for state: EmployeeListDataProvider.State) {
        switch state {
        case .error(let errorDescription):
            self.employeeListView.isHidden = true
            self.loadingStateView.isHidden = false
            self.loadingIndicator.stopAnimating()
            self.stateLabel.text = errorDescription
        case .loading:
            self.employeeListView.isHidden = true
            self.loadingStateView.isHidden = false
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            self.stateLabel.text = Strings.loadingLabelTitle
        case .data(let employees):
            self.employeeListView.isHidden = false
            self.loadingStateView.isHidden = true
            self.applySnaphot(with: employees)
        }
    }
    
    private func applySnaphot(with employees: [Employee]) {
        let section = EmployeeListSection(employees: employees)
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(section.employees)
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Utilities
    
    private func setupLayout() {
        self.view.addSubview(self.employeeListView)
        self.view.addSubview(self.loadingStateView)
        
        NSLayoutConstraint.activate([
            self.employeeListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.employeeListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.employeeListView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.employeeListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingStateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingStateView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.loadingStateView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 40.0),
            self.loadingStateView.trailingAnchor.constraint(greaterThanOrEqualTo: self.view.trailingAnchor, constant: 40.0),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = Strings.navigationTitle
        
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshEmployeeList))
        self.navigationItem.rightBarButtonItem = refreshItem
    }
    
    private func setupSubscriptions() {
        self.stateSubscriber = self.dataProvider
            .$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let this = self else { return }
                
                this.setupUI(for: state)
            })
    }
}

extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EmployeeCell else { return }
        
        cell.initatePhotoLoad()
    }
}
