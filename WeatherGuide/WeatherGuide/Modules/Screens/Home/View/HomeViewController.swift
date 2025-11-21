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
    private var homeViewModel: HomeViewModel = HomeViewModel(viewState: .init(locations: []))
    private var cancellable: Set<AnyCancellable> = []
    
    private lazy var hostingViewController: UIHostingController<some View> = {
        let homeView = HomeView(viewModel: homeViewModel)
            .environment(\.managedObjectContext, CoreDataStack.shared.persistentContainer.viewContext)
        let host = UIHostingController(rootView: homeView)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = UIColor(named: "Base")
        return host
    }()
    
    private lazy var addLocationButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addLocationBtnClick(_:)))
        button.tintColor = UIColor(named: "Mauve")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(named: "Base")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Mauve")
        navigationItem.rightBarButtonItem = addLocationButton
        navigationItem.title = "Weather"
        
        addChild(hostingViewController)
        view.addSubview(hostingViewController.view)
        hostingViewController.didMove(toParent: self)
        
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
                let viewModel = CurrentWeatherViewModel(location: location, viewState: .init(currentTemperature: "", maximumTemperature: "", minimumTemperature: "", sunriseTime: "", sunsetTime: "", humidity: "", weatherStatusImageName: "", windSpeed: ""))
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
            
            switch await homeViewModel.fetchAddressDetails(for: location) {
            case .success(let placemark):
                Task {
                    await homeViewModel.saveLocationToDB(placemark)
                    await homeViewModel.fetchLocationFromDB()
                }
            case .failure(let error):
                throw error
            }
            
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
