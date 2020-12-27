//
//  FavesViewModel.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 27.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation
import CoreData

class FavesViewModel: BaseVM {
    
    private var responseModel: StationTabel
    private var controller : NSFetchedResultsController<StationTabel>!
    
    init(model: StationTabel = StationTabel()) {
        self.responseModel = model
    }
        
    func attemptFetch() {
        setState(.loading)
        let fetchRequest :NSFetchRequest<StationTabel> = StationTabel.fetchRequest()
        
        let datasort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [datasort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        controller.delegate = self
        self.controller = controller
        
        do{
            try controller.performFetch()
            setState(.success)
        }
        catch{
            let error = error as NSError
            setState(.error(error.debugDescription))
        }
    }
    
    var title: String  {
        if !(controller.fetchedObjects?.isEmpty ?? false) {
            return "Favourites (\(controller.fetchedObjects?.count ?? 0))"
        } else {
            return "Favourites"
        }
    }
    
    func getNumberOfRow(section: Int) -> Int {
        if controller != nil ,
           let sections = controller.sections {
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }
        return 0
    }
    
    func getStationItemAtIndex(indexPath: IndexPath) -> StationTabel{
        return controller.object(at:indexPath)
    }
    
    func setNSFetchedResultsControllerDelegate<D: NSFetchedResultsControllerDelegate>(_ delegate: D) {
        controller.delegate = delegate
    }
}
