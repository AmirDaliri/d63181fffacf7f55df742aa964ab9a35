//
//  FaveTableViewCellViewModel.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 27.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit
import CoreData

class FaveTableViewCellViewModel: BaseVM {
    
    private var stationTabel: StationTabel
    private var controller : NSFetchedResultsController<StationTabel>!

    init(model: StationTabel = StationTabel(), idexPath: IndexPath) {
        self.stationTabel = model
        self.index = idexPath
    }

    var name: String {
        return stationTabel.name ?? ""
    }
    
    var eus: String {
        return "\(stationTabel.capacity)/\(stationTabel.need)"
    }
    
    var index: IndexPath
    
    func removeItem() {
        if controller != nil {
            let item  = self.controller.object(at: index)
            context.delete(item)
            appDelegate.saveContext()
        } else {
            attemptFetch()
        }
    }
    
    func attemptFetch() {
        let fetchRequest :NSFetchRequest<StationTabel> = StationTabel.fetchRequest()
        let datasort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [datasort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        do{
            try controller.performFetch()
            self.removeItem()
        }
        catch {}
    }
}
