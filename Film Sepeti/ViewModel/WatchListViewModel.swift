//
//  WatchListViewModel.swift
//  Film Sepeti
//
//  Created by mert can çifter on 15.05.2022.
//

import Foundation
import UIKit
import CoreData

protocol WatchListViewModelProtocol {
    var delegate: WatchListViewModelDelegate? { get set }
    func load()
    func selectWatch(at index : Int)
}

enum WatchListViewModelOutput {
    case setLoading(Bool)
    case showWatchList([Watch])
}

enum WatchListViewRoute{
    case addOrUpdate(AddWatchViewModelProtocol)
}

protocol WatchListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: WatchListViewModelOutput)
    func navigate(to route : WatchListViewRoute)
}

final class WatchListViewModel: WatchListViewModelProtocol {
    var delegate: WatchListViewModelDelegate?
    
    var items: [Watch] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    func load() {
        do {
            let request = Watch.fetchRequest() as NSFetchRequest<Watch>
            let date = Date()
            let pred = NSPredicate(format: "date > %@", date as NSDate)
            request.predicate = pred
            items = try context.fetch(request)
            notify(.showWatchList(items))
        } catch {
            
        }
    }
    
    func selectWatch(at index: Int) {
        let movie = items[index]
        let viewModel = AddWatchViewModel(watch: movie, watchName: "")
        delegate?.navigate(to: .addOrUpdate(viewModel))
    }
    
    private func notify(_ output: WatchListViewModelOutput){
        delegate?.handleViewModelOutput(output)
    }
    
    
}
