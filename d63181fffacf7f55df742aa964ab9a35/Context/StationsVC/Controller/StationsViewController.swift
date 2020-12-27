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
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var ugsLabel: UILabel! {
        didSet {
            ugsLabel.text = viewModel.getUGS(parameter: (self.data as? Spacecraft)?.capacity)
        }
    }
    @IBOutlet private weak var eusLabel: UILabel! {
        didSet {
            eusLabel.text = viewModel.getEUS(parameter: (self.data as? Spacecraft)?.spped)
        }
    }
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var dsLabel: UILabel! {
        didSet {
            dsLabel.text = viewModel.getDS(parameter: (self.data as? Spacecraft)?.durability)
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = (self.data as? Spacecraft)?.name
        }
    }
    
    // MARK: - Properties
    private var viewModel = StationsViewModel()
    private var disposal = Disposal()
    private var searchedList: [Station]?

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        isNavigationBarHidden = true
        bindUI()
        viewModel.delegate = self
        viewModel.startTimer()
        viewModel.getStations()        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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


// MARK: - UISearchBarDelegate Method
extension StationsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.filterWithName(searchBar.text) {
            self.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            delay(0.1) {
                searchBar.resignFirstResponder()
                self.viewModel.resetFilter {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - StationsVMDelegate Method
extension StationsViewController: StationsVMDelegate {
    func timerUpdated(second: String, timeIsUP: Bool) {
        timerLabel.text = second
    }
}
