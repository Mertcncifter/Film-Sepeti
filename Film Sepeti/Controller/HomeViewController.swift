//
//  HomeViewController.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import UIKit
import SkeletonView
import FittedSheets

private let reuseIdentifier = "MovieCell"

class HomeViewController: UITableViewController,SkeletonTableViewDataSource {
    
    // MARK: - Properties
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Film Ara"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    
    var viewModel: HomeViewModelProtocol! {
        didSet {
                viewModel.delegate = self
        }
    }
    
    private var movieList = [Movie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 80
        configureUI()
        viewModel.load()
    }
    
        

    
    // MARK: - API
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureSearchBar()
        tableView.register(MovieCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    func configureSearchBar(){
        navigationItem.title = "Filmler"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.setValue("Kapat", forKey: "cancelButtonText")
    }
    
    
    func configureSkeleton(_ isShow: Bool){
        if isShow {
            DispatchQueue.main.async {
                self.tableView.isSkeletonable = true
                self.tableView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
            }
        }
        else {
            DispatchQueue.main.async {
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
            }
            
        }
    }
    
    func showAddWatchViewController(viewModel: AddWatchViewModelProtocol){
        let viewController = AddWatchViewController()
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .setLoading(let isLoading):
            configureSkeleton(isLoading)
        case .setLoadingSearch(let isLoading):
            DispatchQueue.main.async {
                guard let resultsController = self.searchController.searchResultsController as? SearchResultsViewController else { return }
                resultsController.configureSkeleton(isLoading)
            }
        case .showMovieList(let movieList):
            self.movieList = movieList
        case .searchMovieList(let movieList):
            DispatchQueue.main.async {
                guard let resultsController = self.searchController.searchResultsController as? SearchResultsViewController else { return }
                resultsController.movieList = movieList
            }
        }
    }
    
    func navigate(to route: HomeViewRoute) {
        switch route {
        case .add(let viewModel):
            showAddWatchViewController(viewModel: viewModel)
        }
    }
}


// MARK: - UITableViewDataSource

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return reuseIdentifier
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMovie(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath) as! MovieCell
        cell.movie = movieList[indexPath.row]
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
        }
            
        resultsController.delegate = self
        
        viewModel.search(with: query)
    }
}


extension HomeViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ movie: Movie) {
        let name = (movie.original_title ?? movie.original_name) ?? ""
        let viewModel = AddWatchViewModel(watch: nil, watchName: name)
        showAddWatchViewController(viewModel: viewModel)
    }
}
