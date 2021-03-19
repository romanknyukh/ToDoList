//
//  DetailsViewController.swift
//  LearnTodoListApp
//
//  Created by Roman Knuyh on 8.02.21.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    // MARK: - Enumeration
    enum DetailsType {
        case create
        case editing
    }

    // MARK: - closures
    var closeAction: ((_ note: Note?) -> Void)?

    // MARK: - Variables
    private var edgeInsets = UIEdgeInsets(all: 20) {
        didSet {
            self.view.setNeedsUpdateConstraints()
        }
    }
    private var type: DetailsType
    private var model: Note?

    private var priorities: [String] = [Note.Priority.high.rawValue,
                                        Note.Priority.medium.rawValue,
                                        Note.Priority.low.rawValue]

    // MARK: - GUI Variables
    private var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray

        return view
    }()

    private var priorityView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue

        return view
    }()

    private var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Note.Priority.high.rawValue,
                                                 Note.Priority.medium.rawValue,
                                                 Note.Priority.low.rawValue])
        control.selectedSegmentIndex = 0
        control.addTarget(self,
                          action: #selector(changePriority),
                          for: .valueChanged)

        return control
    }()

    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.backgroundColor = .white

        return textField
    }()

    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white

        return textView
    }()

    private var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Save", for: .normal)
        button.addTarget(self,
                         action: #selector(closeButtonAction),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - Initialization
    init(type: DetailsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.addSubview(self.mainView)
        self.mainView.addSubviews([self.priorityView,
                                   self.segmentedControl,
                                   self.titleTextField,
                                   self.descriptionTextView,
                                   self.closeButton])
        self.makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupNavigationBar()
    }

    // MARK: - NavigationBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Details"
        // self.navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Constraints
    func makeConstraints() {
        self.mainScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.mainView.snp.makeConstraints { (make) in
            make.size.edges.equalToSuperview()
        }

        self.priorityView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(20)
        }

        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.priorityView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        self.titleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(50)
        }

        self.descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionTextView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
            make.height.equalTo(50)
        }
    }

    // MARK: - Setter
    func set(with model: Note) {
        self.model = model

        if let model = self.model {
            self.segmentedControl.selectedSegmentIndex = self.priorities.firstIndex(of: model.priority.rawValue) ?? 0
            self.priorityView.backgroundColor = model.priority.priorityColor

            self.titleTextField.text = model.title
            self.descriptionTextView.text = model.description
        }

        self.view.setNeedsUpdateConstraints()
    }

    // MARK: - Action
    @objc private func closeButtonAction() {
        self.model?.title = self.titleTextField.text ?? "Empty title"
        self.model?.description = self.descriptionTextView.text
        self.closeAction?(model)

        self.dismiss(animated: true)
    }

    @objc private func changePriority() {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.model?.priority = .high
        case 1:
            self.model?.priority = .medium
        case 2:
            self.model?.priority = .low
        default:
            break
        }
        self.priorityView.backgroundColor = self.model?.priority.priorityColor
    }
}
