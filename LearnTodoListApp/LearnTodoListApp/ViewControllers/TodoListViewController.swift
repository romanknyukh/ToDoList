//
//  TodoListViewController.swift
//  LearnTodoListApp
//
//  Created by Roman Knuyh on 8.02.21.
//

import UIKit

class TodoListViewController: UIViewController {
    // MARK: - Variables
    private var model: [Note] = []

    // MARK: - GUI Variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        // Type 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListCell.self,
                           forCellReuseIdentifier: TodoListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Type 2
        // self.tableView.delegate = self
        // self.tableView.dataSource = self

        self.view.addSubview(self.tableView)
        self.setupTableViewConstraints()

        self.setupNavigationBar()
    }

    // MARK: - Constraints
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(self.addButtonAction))
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem].reversed()
    }

    // MARK: - Methods
    func set(for profile: Profile) {
        self.navigationItem.title = "TodoList for \(profile.username)"
    }

    private func openEditViewController(with model: Note, and indexPath: IndexPath) {
        let vc = DetailsViewController(type: .editing)
        vc.set(with: model)
        vc.closeAction = { [weak self] model in
            guard let self = self, let model = model else { return }
            self.model[indexPath.row] = model
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.navigationController?.present(vc, animated: true)
    }

    // MARK: - Actions
    @objc private func addButtonAction() {
        self.tableView.performBatchUpdates {
            let newNote = Note(title: "New Note",
                               description: "Note description",
                               priority: .low,
                               date: Date())
            self.model.insert(newNote, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        } completion: { (success) in
            Swift.debugPrint(success)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: TodoListCell.reuseIdentifier,
            for: indexPath)
        if let cell = cell as? TodoListCell {
            cell.set(title: self.model[indexPath.row].title,
                     description: self.model[indexPath.row].description,
                     date: self.model[indexPath.row].date)
            cell.setPriority(for: self.model[indexPath.row].priority)
            cell.selectionStyle = .none
        }

        return cell
    }

    // Tap on cell to show information
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Swift.debugPrint(self.model[indexPath.row])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    // Basic swipe gestures to open menu and remove cells
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        /* switch editingStyle {
        case .delete:
            Swift.debugPrint("delete")
            self.tableView.performBatchUpdates({
                self.model.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: { (isSuccess) in
                Swift.debugPrint(isSuccess
                    ? "Row was deleted"
                    : "Couldn't delete this row")
            })
        case .insert:
            Swift.debugPrint("Try to insert cells")
        default:
            break
        } */
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Remove Action
        let remove = UIContextualAction(
            style: .destructive,
            title: "Remove") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.tableView.performBatchUpdates({
                self.model.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: { (isSuccess) in
                Swift.debugPrint(isSuccess
                    ? "Row was deleted"
                    : "Couldn't delete this row")
                completionHandler(isSuccess)
            })
        }
        remove.backgroundColor = .systemRed

        // Edit Action
        let edit = UIContextualAction(
            style: .normal,
            title: "Edit") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.openEditViewController(with: self.model[indexPath.row], and: indexPath)

            completionHandler(true)
        }
        edit.backgroundColor = .systemOrange

        return UISwipeActionsConfiguration(actions: [remove, edit])
    }

    // Move cells
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        self.tableView.performBatchUpdates({
            self.model.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
        }, completion: { _ in
            // TODO: - Save your model to storage
            self.tableView.reloadData()
        })
    }
}
