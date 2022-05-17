//
//  SearchResultsViewController.swift
//  Film Sepeti
//
//  Created by mert can çifter on 5.05.2022.
//

import UIKit
import SkeletonView


protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ movie: Movie)
}

private let reuseIdentifier = "SearchMovieCell"

class SearchResultsViewController: UITableViewController,SkeletonTableViewDataSource {
    
    
    // MARK: - Properties
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public var movieList = [Movie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .white
        tableView.dataSource = self
        configureUI()
    }
    

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Filmler"
        tableView.register(MovieCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    func configureSkeleton(_ isShow: Bool){
        if isShow {
            DispatchQueue.main.async {
                self.tableView.isSkeletonable = true
                self.tableView.showAnimatedGradientSkeleton()
            }
        }
        else {
            DispatchQueue.main.async {
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
            }
            
        }
    }

}





// MARK: - UITableViewDataSource

extension SearchResultsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return reuseIdentifier
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchResultsViewControllerDidTapItem(movieList[indexPath.row])
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath) as! MovieCell
        cell.movie = movieList[indexPath.row]
        return cell
    }
}




