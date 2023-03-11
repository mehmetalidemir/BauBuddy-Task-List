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
        DataManager.shared.fetchTasks { result in
            switch result{
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

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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
    }


    @IBAction func refreshButtonTapped(_ sender: Any) {
       

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? tasks.count : tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell

        let task = tasks[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.task
        cell.taskLabel.text = task.task
        cell.colorCodeLabel.text = task.colorCode
        cell.backgroundColor = hexStringToUIColor(hex: task.colorCode)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
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
}

