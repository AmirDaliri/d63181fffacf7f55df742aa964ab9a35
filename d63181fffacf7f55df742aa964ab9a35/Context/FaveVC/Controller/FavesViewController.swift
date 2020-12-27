//
//  FavesViewController.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import UIKit
import CoreData

class FavesViewController: BaseVC {

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(cellClass: FaveTableViewCell.self)
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: - Properties
    private var viewModel = FavesViewModel()
    private var disposal = Disposal()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        isNavigationBarHidden = false
        bindUI()
        viewModel.attemptFetch()
    }
    
    // MARK: - Private Method
    private func bindUI() {
        viewModel.state.observe { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .success:
                self.updateUI()
                self.viewModel.setupEmptyView(tableView: self.tableView)
            case .error(let err):
                self.handleAlertView(title: nil, message: err ?? "")
            default:
                break
            }
        }.add(to: &disposal)
    }
    
    private func updateUI() {
        tableView.reloadData()
        viewModel.setNSFetchedResultsControllerDelegate(self)
        pageTitle = viewModel.title
    }
}

// MARK: - Table Delegate Datasource

extension FavesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRow(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FaveTableViewCell.reuseIdentifier, for: indexPath) as! FaveTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func configureCell(cell : FaveTableViewCell , indexPath: NSIndexPath) {
        let item  = viewModel.getStationItemAtIndex(indexPath: indexPath as IndexPath)
        cell.faveTableViewCellViewModel = FaveTableViewCellViewModel(model: item, idexPath: indexPath as IndexPath)
    }
}

// MARK: - NSFetchedResultsControllerDelegate Method

extension FavesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .right)
                tableView.backgroundView = nil
                viewModel.attemptFetch()
            }
            break
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
                viewModel.attemptFetch()
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! FaveTableViewCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        /**
            Move Item

            - SeeAlso: move cell with drag and drop

            - Version: 1.0

            - Author: amir daliri

            - Note: not implemented
        **/
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        @unknown default:
            fatalError()
        }
    }
}
