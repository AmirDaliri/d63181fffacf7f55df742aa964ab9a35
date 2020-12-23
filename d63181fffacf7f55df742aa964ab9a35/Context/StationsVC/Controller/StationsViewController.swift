//
//  StationsViewController.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class StationsViewController: BaseVC {

    //MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellClass: StationsCollectionViewCell.self)
            setCollectionViewDataSourceDelegate(self)
        }
    }
    
    // MARK: - Properties
    private var viewModel = StationsViewModel()
    private var disposal = Disposal()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        isNavigationBarHidden = true
        bindUI()
        viewModel.getStations()
    }

    // MARK: - Private Method
    private func bindUI() {
        viewModel.state.observe { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .success:
                self.updateUI()
            case .error(let err):
                self.handleAlertView(title: nil, message: err ?? "")
            default:
                break
            }
        }.add(to: &disposal)
    }
    
    private func updateUI() {
        collectionView.reloadData()
    }
    
    @IBAction func nextPageButtonClicked(_ sender: UIButton) {
        /*
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < viewModel.numberOfRows {
            self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }
        */
        
        /*
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray

        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        for itr in visibleItems {
            if minItem.row > (itr as AnyObject).row {
                minItem = itr as! NSIndexPath
            }
        }
        print(minItem.row)
        print(viewModel.numberOfRows)
        if (minItem.row) < (viewModel.numberOfRows) {
            let nextItem = NSIndexPath(row: minItem.row + 1, section: 0)
            self.collectionView.scrollToItem(at: nextItem as IndexPath, at: .left, animated: true)
        } else {
            sender.isEnabled = false
        }
        */
        
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < viewModel.numberOfRows {
            self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }
    }
    
    @IBAction func previousPageButtonClicked(_ sender: UIButton) {
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        var minItem: NSIndexPath = visibleItems.object(at: 0) as! NSIndexPath
        for itr in visibleItems {

            if minItem.row > (itr as AnyObject).row {
                minItem = itr as! NSIndexPath
            }
        }
        let nextItem = NSIndexPath(row: minItem.row - 1, section: 0)
        self.collectionView.scrollToItem(at: nextItem as IndexPath, at: .right, animated: true)
    }
    
}

// MARK: - UICollectionView Delegate Datasource

extension StationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StationsCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: StationsCollectionViewCell.reuseIdentifier, for: indexPath as IndexPath) as? StationsCollectionViewCell)!
        let stationsCollectionCellViewModel = viewModel.createStationsCollectionCellViewModel(indexPath.row)
        cell.stationsCollectionCellViewModel = stationsCollectionCellViewModel
        return cell
    }
    
    // MARK: - CollectionView Parameters Configure
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D) {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/1.15, height: CGFloat(210))
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
    }
}
