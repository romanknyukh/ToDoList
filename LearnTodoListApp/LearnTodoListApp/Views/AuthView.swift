//
//  AuthView.swift
//  LearnTodoListApp
//
//  Created by Roman Knuyh on 8.02.21.
//

import UIKit
import SnapKit

class AuthView: UIView {
    // MARK: - Closures
    var action: ((_ profile: Profile) -> Void)?

    // MARK: - Variables
    private let edgeInsets = UIEdgeInsets(all: 20)
    private let imageSize = CGSize(width: 200, height: 200)
    private let itemHeight: CGFloat = 50

    // MARK: - GUI Variables
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter username"
        textfield.backgroundColor = .white
        textfield.clearButtonMode = .whileEditing

        return textfield
    }()

    private lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter password"
        textfield.backgroundColor = .white
        textfield.clearButtonMode = .whileEditing

        return textfield
    }()

    private(set) lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)

        return button
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        self.backgroundColor = .lightGray

        self.addSubviews([self.imageView,
                          self.titleLabel,
                          self.usernameTextField,
                          self.passwordTextField,
                          self.continueButton])
        self.constraints()
    }

    // MARK: - Constraints
    private func constraints() {
        self.imageView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(self.edgeInsets.top)
            make.size.equalTo(self.imageSize)
            make.centerX.equalToSuperview()
        }

        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(20)
            make.left.right.greaterThanOrEqualToSuperview().inset(self.edgeInsets)
            make.centerX.equalToSuperview()
        }

        self.usernameTextField.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(self.itemHeight)
        }

        self.passwordTextField.snp.updateConstraints { (make) in
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(self.itemHeight)
        }

        self.continueButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(self.itemHeight)
        }
    }

    // MARK: - Methods
    func setImage(with imageName: String) {
        self.imageView.image = UIImage(named: imageName)

        self.setNeedsUpdateConstraints()
    }

    func setTitle(with text: String) {
        self.titleLabel.text = text

        self.setNeedsUpdateConstraints()
    }

    // MARK: - Actions
    @objc private func buttonPressed() {
        guard let username = self.usernameTextField.text, !username.isEmpty,
              let password = self.passwordTextField.text, !password.isEmpty else { return }

        var profile = Profile(username: username, password: password)
        profile.profileImage = "default"
        self.action?(profile)
    }
}
