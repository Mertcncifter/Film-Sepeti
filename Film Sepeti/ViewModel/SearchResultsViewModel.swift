//
//  SearchResultsViewModel.swift
//  Film Sepeti
//
//  Created by mert can çifter on 5.05.2022.
//

import Foundation

protocol SearchResultsViewModelProtocol {
    var delegate: SearchResultsViewModelDelegate? { get set }
    func load()
    func selectMovie(at index : Int)
}

enum SearchResultsViewModelOutput {
    case setLoading(Bool)
    case showMovieList([Movie])
}

enum SearchResultsViewRoute{
    case detail(SearchResultsViewModelProtocol)
}

protocol SearchResultsViewModelDelegate: class {
    func handleViewModelOutput(_ output: SearchResultsViewModelOutput)
    func navigate(to route : SearchResultsViewRoute)
}

final class SearchResultsViewModel: SearchResultsViewModelProtocol {
    weak var delegate: SearchResultsViewModelDelegate?
    private var movies: [Movie] = []
    
    func load() {
        notify(.setLoading(true))
        let queryParameters: [String : String] = [
                                                "api_key" : AppConstants.API_KEY
                                                ]
        let request = DataRequest(url: Network.trendMovie.value, method: .get,queryItems: queryParameters)
        NetworkService.shared.request(request) { (result) in
            self.notify(.setLoading(false))
            switch result {
            case .success(let response):
                self.movies = response
                self.notify(.showMovieList(self.movies))
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func selectMovie(at index: Int) {
        
    }
    
    private func notify(_ output: SearchResultsViewModelOutput){
        delegate?.handleViewModelOutput(output)
    }
    
    
}
