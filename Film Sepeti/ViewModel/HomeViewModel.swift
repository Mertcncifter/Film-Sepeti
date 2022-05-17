//
//  HomeViewModel.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import Foundation


protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func load()
    func search(with query : String)
    func selectMovie(at index : Int)
}

enum HomeViewModelOutput {
    case setLoading(Bool)
    case setLoadingSearch(Bool)
    case showMovieList([Movie])
    case searchMovieList([Movie])
}

enum HomeViewRoute{
    case add(AddWatchViewModelProtocol)
}

protocol HomeViewModelDelegate: class {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
    func navigate(to route : HomeViewRoute)
}


final class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    private var movies: [Movie] = []
    
    func load() {
        notify(.setLoading(true))
        let queryParameters: [String : String] = [
                                                "api_key" : AppConstants.API_KEY
                                                ]
        let request = DataRequest(url: Network.trendMovie.value, method: .get,queryItems: queryParameters)
        NetworkService.shared.request(request) { (result) in
            switch result {
            case .success(let response):               
                self.movies = response
                self.notify(.showMovieList(self.movies))
                self.notify(.setLoading(false))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func search(with query: String) {
        notify(.setLoadingSearch(true))
        let queryParameters: [String : String] = [
                                                "api_key" : AppConstants.API_KEY,
                                                "query" : query
                                                ]
        let request = DataRequest(url: Network.searchMovie.value, method: .get,queryItems: queryParameters)
        NetworkService.shared.request(request) { (result) in
            switch result {
            case .success(let response):
                self.movies = response
                self.notify(.searchMovieList(self.movies))
                self.notify(.setLoadingSearch(false))
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func selectMovie(at index: Int) {
        let movie = movies[index]
        let name = (movie.original_title ?? movie.original_name) ?? "Unknown title name"
        let viewModel = AddWatchViewModel(watch: nil, watchName: name)
        delegate?.navigate(to: .add(viewModel))
    }
    
    private func notify(_ output: HomeViewModelOutput){
        delegate?.handleViewModelOutput(output)
    }
    
    
}
