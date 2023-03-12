//
//  ViewController.swift
//  VERODigitalSolutions-iOSTask
//
//  Created by Mehmet Ali Demir on 1.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var tasks: [Task] = []
    var isSearching: Bool = false



    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefreshControl()

        if let savedTasksData = UserDefaults.standard.data(forKey: "tasks") {
            let decoder = JSONDecoder()
            if let savedTasks = try? decoder.decode([Task].self, from: savedTasksData) {
                tasks = savedTasks
                tableView.reloadData()
            }
        } else {
            NetworkManager.shared.fetchTasks { result in
                switch result {
                case .success(let tasks):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.tasks = tasks
                        self.tableView.reloadData()
                        self.saveTasksToUserDefaults()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        NetworkManager.shared.fetchTasks { result in
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tasks = tasks
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }


    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    private func saveTasksToUserDefaults() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: "tasks")
        }
    }

    private func loadTasksFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: "tasks"),
            let decodedTasks = try? decoder.decode([Task].self, from: savedData) {
            tasks = decodedTasks
            tableView.reloadData()
        }
    }



    private func filterTasks(for searchText: String) {
        isSearching = true
        tasks = tasks.filter { task in
            task.title.contains(searchText) || task.description.contains(searchText)
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func resetSearch() {
        isSearching = false
        searchBar.text = nil
        loadTasksFromUserDefaults()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }



    @IBAction func refreshButtonTapped(_ sender: Any) {
        NetworkManager.shared.fetchTasks { result in
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tasks = tasks
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? tasks.count : tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell

        let task = tasks[indexPath.row]

        cell.titleLabel.text = "Title: \(task.title)"
        cell.descriptionLabel.text = "Description: \(task.description)"
        cell.taskLabel.text = "Task: \(task.task)"
        cell.colorCodeLabel.text = "Color Code: \(task.colorCode)"
        cell.backgroundColor = UIColor(hexString: task.colorCode)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resetSearch()
        } else {
            filterTasks(for: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        resetSearch()
        searchBar.resignFirstResponder()
    }
}


