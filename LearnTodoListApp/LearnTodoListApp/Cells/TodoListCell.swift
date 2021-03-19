//
//  TodoListCell.swift
//  LearnTodoListApp
//
//  Created by Roman Knuyh on 8.02.21.
//

import UIKit
import SnapKit

class TodoListCell: UITableViewCell {
    // MARK: - Idetifier
    static let reuseIdentifier = "TodoListCellIdentifier"

    // MARK: - Variables
    private(set) var edgeInsets = UIEdgeInsets(all: 20) {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }

    private var contentEdgeInsets = UIEdgeInsets(all: 16)

    private let arrowSize = CGSize(width: 24, height: 24)
    private var cornerRadius: CGFloat = 16
    private let priorityOffset: CGFloat = 16

    var priorityWidth: CGFloat = 25 {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }

    // MARK: - GUI Variables
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray

        return view
    }()

    private lazy var priorityView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = self.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        return view
    }()

    private lazy var mainView = UIView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .right
        label.textColor = .black

        return label
    }()

    private lazy var arrowIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "arrowtriangle.right")
        icon.tintColor = .black
        icon.contentMode = .scaleAspectFill

        return icon
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubviews([self.priorityView, self.mainView])
        self.mainView.addSubviews([
            self.titleLabel,
            self.arrowIcon,
            self.descriptionLabel,
            self.dateLabel
        ])

        self.setupCellStyle()
    }

    // MARK: - Methods
    private func setupCellStyle() {
        self.containerView.layer.shadowColor = UIColor.darkGray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.containerView.layer.shadowRadius = self.cornerRadius
        self.containerView.layer.shadowOpacity = 0.3

        self.containerView.layer.cornerRadius = self.cornerRadius
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.black.cgColor
    }

    // MARK: - Constraints
    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.edgeInsets)
        }

        self.priorityView.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.priorityWidth)
        }

        self.mainView.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.priorityView.snp.right)
        }

        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.contentEdgeInsets)
        }

        self.arrowIcon.snp.updateConstraints { (make) in
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(self.contentEdgeInsets)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.size.equalTo(self.arrowSize)
        }

        self.descriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(self.contentEdgeInsets)
        }

        self.dateLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(10)
            make.left.greaterThanOrEqualToSuperview().inset(self.contentEdgeInsets)
            make.right.bottom.equalToSuperview().inset(self.contentEdgeInsets)
        }

        super.updateConstraints()
    }

    // MARK: - Setter
    func setPriority(for type: Note.Priority) {
        self.priorityView.backgroundColor = type.priorityColor
    }

    func set(title: String,
             description: String? = nil,
             date: Date) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        self.dateLabel.text = dateFormatter.string(from: date)

        self.setNeedsUpdateConstraints()
    }
}
