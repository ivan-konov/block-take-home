//
//  EmployeeCell.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import UIKit
import SDWebImage

/// A table view cell displaying an employee's details.
final class EmployeeCell: UITableViewCell {
    private struct Strings {
        static let biographyTitle = NSLocalizedString("Biography:", comment: "A title for an employee biography label.")
    }
    
    /// The reuse identifier for the cell to be used by a `UITableView`.
    static let reuseIdentifier = "EmployeeCell"
    private var employee: Employee? = nil
    
    // MARK: - UI
    
    private lazy var mainContainerView: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alignment = .center
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        container.spacing = 20.0
        return container
    }()
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private lazy var infoContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [
            self.nameLabel,
            self.additionalInfoContainer,
            self.biographyTitleLabel,
            self.biographySeparator,
            self.biographyLabel,
        ])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 5.0
        container.setCustomSpacing(15.0, after: self.additionalInfoContainer)
        container.axis = .vertical
        return container
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var additionalInfoContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [self.teamLabel, self.typeLabel])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 10.0
        return container
    }()
    
    private lazy var teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .subheadline, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var biographyTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = Strings.biographyTitle
        label.font = .preferredFont(for: .subheadline, weight: .bold)
        return label
    }()
    
    private lazy var biographySeparator: UIView = {
        let view =  UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryLabel
        return view
    }()
    
    private lazy var biographyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization and Reuse
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.mainContainerView.addArrangedSubview(self.photoView)
        self.mainContainerView.addArrangedSubview(self.infoContainer)
        self.contentView.addSubview(self.mainContainerView)
        
        NSLayoutConstraint.activate([
            self.mainContainerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.mainContainerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.mainContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.mainContainerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.photoView.widthAnchor.constraint(equalToConstant: 70.0),
            self.photoView.heightAnchor.constraint(equalToConstant: 70.0),
            self.biographySeparator.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.teamLabel.text = nil
        self.typeLabel.text = nil
        self.biographyLabel.text = nil
        self.photoView.image = nil
        self.toggleBiographyDisplay(hidden: false)
    }
    
    private func toggleBiographyDisplay(hidden: Bool) {
        self.biographyTitleLabel.isHidden = hidden
        self.biographySeparator.isHidden = hidden
        self.biographyLabel.isHidden = hidden
    }
    
    // MARK: - Public API
    
    /// Configure the cell's content with an employee's data.
    /// - Parameter employee: The employee whose details are to be displayed.
    func configure(with employee: Employee) {
        self.employee = employee
        
        self.nameLabel.text = employee.fullName
        self.teamLabel.text = employee.team
        self.typeLabel.text = employee.type.displayString.uppercased()
        if let biography = employee.biography {
            self.toggleBiographyDisplay(hidden: false)
            self.biographyLabel.text = biography
        } else {
            self.toggleBiographyDisplay(hidden: true)
            self.biographyLabel.text = nil
        }
    }
    
    /// Initates lod of the associated employee photo either from disk cache or network.
    func initatePhotoLoad() {
        let placeholderImage = UIImage(systemName: "person.crop.circle")
        let imageURL = self.employee?.photos?.photoURL(for: .small)
        self.photoView.sd_setImage(with: imageURL, placeholderImage: placeholderImage) { [weak self] _, _, _, _ in
            guard let this = self else { return }
            
            this.photoView.layer.cornerRadius = this.photoView.frame.width / 2
        }
    }
}
