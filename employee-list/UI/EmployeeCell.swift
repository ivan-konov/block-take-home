//
//  EmployeeCell.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import UIKit
import SDWebImage

final class EmployeeCell: UITableViewCell {
    static let reuseIdentifier = "EmployeeCell"
    
    private var employee: Employee? = nil
    
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private lazy var infoContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [self.nameLabel, self.additionalInfoContainer, self.biographyLabel])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 5.0
        container.setCustomSpacing(10.0, after: self.self.additionalInfoContainer)
        container.axis = .vertical
        return container
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
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
        label.font = .preferredFont(forTextStyle: .subheadline)
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
    
    private lazy var biographyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .tertiaryLabel
        return label
    }()
    
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
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.photoView.layer.cornerRadius = self.photoView.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.teamLabel.text = nil
        self.typeLabel.text = nil
        self.biographyLabel.text = nil
        self.photoView.image = nil
    }
    
    func configure(with employee: Employee) {
        self.employee = employee
        
        self.nameLabel.text = employee.fullName
        self.teamLabel.text = employee.team
        self.typeLabel.text = employee.type.displayString
        self.biographyLabel.text = employee.biography
    }
    
    func initatePhotoLoad() {
        self.photoView.sd_setImage(with: self.employee?.photos?.photoURL(for: .small))
    }
}
