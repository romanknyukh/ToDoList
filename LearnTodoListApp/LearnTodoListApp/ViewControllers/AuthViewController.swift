//
//  AuthViewController.swift
//  LearnTodoListApp
//
//  Editied by Roman Knuyh on 8.02.21.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    // MARK: - Variables
    private let edgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    // MARK: - GUI Variables
    private lazy var mainView: AuthView = {
        let view = AuthView()
        view.setTitle(with: "My best greetings to User!")
        view.continueButton.setTitle("Continue", for: .normal)
        view.action = { [weak self] (profile) in
            self?.openTodoList(for: profile)
        }

        return view
    }()

    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .red
        self.view.addSubview(self.mainView)

        self.mainView.setImage(with: "profile")
        // self.mainView.action = {
        //    // TODO: - add your action
        // }

        self.constraints()
    }

    // MARK: - Constraints
    private func constraints() {
        self.mainView.snp.updateConstraints { (make) in
            make.left.right.greaterThanOrEqualToSuperview().inset(self.edgeInsets)
            make.center.equalToSuperview()
        }
    }

    // MARK: - Methods
    private func openTodoList(for profile: Profile) {
        let vc = TodoListViewController()
        vc.set(for: profile)

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

