//
//  StationsCollectionViewCell.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit
import CoreData

class StationsCollectionViewCell: BaseCollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.setshadowRadiusView(radius: 12, shadowRadiuss: 1, shadowheight: 5, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.08))
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var eusLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var faveButton: UIButton!
    
    // MARK: - Properties
    var stationsCollectionCellViewModel: StationsCollectionCellViewModel = StationsCollectionCellViewModel() {
        didSet {
            updateUI()
        }
    }
    
    private var stationTabel: StationTabel?
    private var stationTabelController : NSFetchedResultsController<StationTabel>!

    // MARK: - Private Functions
    private func updateUI() {
        nameLabel.text = stationsCollectionCellViewModel.name
        dataLabel.text = "\(stationsCollectionCellViewModel.stock)/\(stationsCollectionCellViewModel.need)"
        fetchGamesSeenIds(name: stationsCollectionCellViewModel.name)
    }
    // MARK: - IBAction Method
    
    @IBAction func faveButtonTapped(_ sender: Any) {
        addToFavorite()
    }
    
    @IBAction func travelButtonTapped(_ sender: Any) {}
    
    // MARK: - coreData Method
    
    func addToFavorite() {
        let tablel = StationTabel(context: context)
        tablel.name = stationsCollectionCellViewModel.name
        tablel.coordinateX = stationsCollectionCellViewModel.coordinateX
        tablel.coordinateY = stationsCollectionCellViewModel.coordinateY
        tablel.need = Int32(stationsCollectionCellViewModel.need)
        tablel.stock = Int32(stationsCollectionCellViewModel.stock)
        tablel.capacity = Int32(stationsCollectionCellViewModel.capacity)
        appDelegate.saveContext()
        faveButton.setImage(#imageLiteral(resourceName: "faved"), for: .normal)
    }
    
    func fetchGamesSeenIds(name: String) {
        
        let fetchRequest :NSFetchRequest<StationTabel> = StationTabel.fetchRequest()
        
        let datasort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [datasort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.stationTabelController = controller
        
        do{
            try controller.performFetch()
        }
        catch{
            let error = error as NSError
            print(error.debugDescription)
        }
        
        if let items = controller.fetchedObjects {
            for i in items {
                if i.name == name {
                    DispatchQueue.main.async {
                        self.faveButton.setImage(#imageLiteral(resourceName: "faved"), for: .normal)
                    }
                } else {
                    self.faveButton.setImage(#imageLiteral(resourceName: "faves"), for: .normal)
                }
            }
        }
    }
}
