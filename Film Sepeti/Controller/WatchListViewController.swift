//
//  WatchListViewController.swift
//  Film Sepeti
//
//  Created by mert can çifter on 10.05.2022.
//

import UIKit
import CoreData

private let reuseIdentifier = "WatchCell"

class WatchListViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    private var floatingButton: UIButton?
    
    var viewModel: WatchListViewModelProtocol! {
        didSet {
                viewModel.delegate = self
        }
    }
    
    private var watchList = [Watch]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        createFloatingButton()
        configureUI()
        configureTableView()
        viewModel.load()
    }
    
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton?.tintColor = .white
        floatingButton?.backgroundColor = .customBlue
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.layer.cornerRadius = 56 / 2
        constrainFloatingButtonToWindow()
        floatingButton?.setImage(UIImage(systemName:  "plus"), for: .normal)
        floatingButton?.addTarget(self, action: #selector(showAddWatchController), for: .touchUpInside)
    }
    
    
    private func constrainFloatingButtonToWindow() {
        guard let keyWindow = UIApplication.shared.keyWindow,
            let floatingButton = self.floatingButton else { return }
        keyWindow.addSubview(floatingButton)
        floatingButton.anchor(bottom: keyWindow.safeAreaLayoutGuide.bottomAnchor, right: keyWindow.rightAnchor,  paddingBottom: 64, paddingRight:  16, width: 56, height: 56)
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floatingButton?.isHidden = false
        viewModel.load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        floatingButton?.isHidden = true
    }
    
 
    
    // MARK: - Selectors
    
    @objc
    func showAddWatchController() {
        let viewModel = AddWatchViewModel(watch: nil, watchName: "")
        showAddWatchViewController(viewModel: viewModel)
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Listem"
    }
    
    func configureTableView(){
        tableView.register(WatchCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
    
    func showAddWatchViewController(viewModel: AddWatchViewModelProtocol){
        floatingButton?.isHidden = true
        let viewController = AddWatchViewController()
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension WatchListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectWatch(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath) as! WatchCell
        let dataRow = watchList[indexPath.row]
        cell.watch = dataRow
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
 
}


// MARK: - WatchListViewModelDelegate

extension WatchListViewController: WatchListViewModelDelegate {
    func handleViewModelOutput(_ output: WatchListViewModelOutput) {
        switch output {
        case .setLoading(let bool):
            print("")
        case .showWatchList(let watchList):
            self.watchList = watchList
        }
    }
    
    func navigate(to route: WatchListViewRoute) {
        switch route {
        case .addOrUpdate(let viewModel):
            showAddWatchViewController(viewModel: viewModel)
        }
    }
}

