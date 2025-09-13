//
//  WGiPhoneHomeVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import MapKit
import SwiftUI
import Combine

class HomeViewController: UIViewController {
    private var viewModel: WGWeatherViewModel = WGWeatherViewModel()
    private var homeViewModel: HomeViewModel = HomeViewModel(viewState: .init(locations: []))
    private var cancellable: Set<AnyCancellable> = []
    
    private lazy var hostingViewController: UIHostingController = {
        let host = UIHostingController(rootView: HomeView(viewModel: homeViewModel))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        return host
    }()
    
    private lazy var addLocationButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addLocationBtnClick(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(named: "Muave")
        navigationItem.rightBarButtonItem = addLocationButton
        navigationItem.title = "Weather"
        
        addChild(hostingViewController)
        view.addSubview(hostingViewController.view)
        hostingViewController.didMove(toParent: self)
        
        //Check if there are any archived data
        let locationList = viewModel.retrieveLocationData()
        
        configureLayout()
        configureObservability()
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Observability
    
    func configureObservability() {
        homeViewModel.$selectedLocation
            .sink { [weak self] location in
                guard let location else { return }
                let viewModel = CurrentWeatherViewModel(location: location)
                let currentWeatherVC: CurrentWeatherViewController = .init(viewModel: viewModel)
                
                self?.navigationController?.pushViewController(currentWeatherVC, animated: true)
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Layout
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            hostingViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.view.rightAnchor.constraint(equalTo: hostingViewController.view.rightAnchor),
            self.view.bottomAnchor.constraint(equalTo: hostingViewController.view.bottomAnchor),
            hostingViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    @objc
    func addLocationBtnClick(_ sender: Any) {
        let locationVC: LocationViewController = .init()
        locationVC.dismissPublisher
            .sink(receiveValue: { [weak self] location in
                Task {
                    await self?.fetchData(for: location)
                }
            })
            .store(in: &cancellable)
        
        navigationController?.present(locationVC, animated: true)
    }
    
    func fetchData(for location: CLLocation) async {
        do {
            DispatchQueue.main.async {
                WGProgressView.showProgressView()
            }
            
            try await homeViewModel.getWeatherData(for: location)
            
            //Refresh UI on main thread
            DispatchQueue.main.async {
                WGProgressView.removeProgressView()
            }
        } catch let error as WGErrorResponse {
            //Remove progressView on main thread and display alert
            DispatchQueue.main.async { [weak self] in
                WGProgressView.removeProgressView()
                self?.showAlert(message: error.localizedDescription)
            }
        } catch let error {
            //Remove progressView on main thread and display alert
            DispatchQueue.main.async { [weak self] in
                WGProgressView.removeProgressView()
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - TableView Delegate methods

/*extension WGHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let timestamp = dataSource[indexPath.row].timestamp {
            let lastDataReceivedTimeStamp = Int(timestamp)
            //Get current time in UTC
            let currentTimeInterval = Int(Date().timeIntervalSince1970)
            let difference = currentTimeInterval - lastDataReceivedTimeStamp
            
            //Request for new weather data if the last received data is stale by an hour
            if difference > 3600 {
                Task {
                    await fetchData(for: .init(latitude: CLLocationDegrees(dataSource[indexPath.row].latitude),
                                               longitude: CLLocationDegrees(dataSource[indexPath.row].longtitude)))
                    
                    let location = self.dataSource[indexPath.row]
                    displayCurrentWeather(for: location)
                }
            } else {
                let location = self.dataSource[indexPath.row]
                displayCurrentWeather(for: location)
            }
        }
    }
    
    func displayCurrentWeather(for location: WGLocation) {
        let viewModel = CurrentWeatherViewModel(location: location)
        let currentWeatherVC: CurrentWeatherViewController = .init(viewModel: viewModel)
        
        navigationController?.pushViewController(currentWeatherVC, animated: true)
    }
}*/

extension HomeViewController: WGWeatherViewModelProtocol {
    func dataSaveFailed(errorMsg: String) {
        showAlert(message: errorMsg)
    }
}

/*extension WGHomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            let nsString = textField.text as NSString?
            if let searchString = nsString?.replacingCharacters(in: range, with: text) {
                viewModel.filterBySearchText(searchText: searchString) { [weak self] (locations) in
                    DispatchQueue.main.async {
                        guard let myself = self, let locList = locations else {
                            return
                        }
                        
                        if locList.isEmpty {
                            myself.dataSource.removeAll()
                        } else {
                            myself.dataSource = locList
                        }
                        
                        myself.tableView.reloadData()
                    }
                }
            }
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
            let searchText = textField.text, searchText == "" {
            self.dataSource = self.viewModel.locations
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.dataSource = self.viewModel.locations
            self.tableView.reloadData()
        }
    }
}*/
