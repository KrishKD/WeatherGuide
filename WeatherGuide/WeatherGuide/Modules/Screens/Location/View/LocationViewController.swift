//
//  LocationViewController.swift
//  WeatherGuide
//
//  Created by krishna on 6/24/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

class LocationViewController: UIViewController {

    private var locationViewModel = LocationMapViewModel()
    private var cancellables: Set<AnyCancellable> = []
    var onDismiss: (CLLocation) -> Void
    
    private lazy var hostingViewController: UIHostingController = {
        let host = UIHostingController(rootView: LocationMapView(with: locationViewModel))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        return host
    }()
    
    // MARK: - Initializer
    
    init(onDismiss: @escaping (CLLocation) -> Void) {
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
            
        // Do any additional setup after loading the view.
        view.addSubview(hostingViewController.view)
    }
    
    func bind() {
        locationViewModel.addLocationSubject
            .sink { [weak self] location in
                if let location {
                    self?.onDismiss(location)
                }
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Layout
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            hostingViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.view.rightAnchor.constraint(equalTo: hostingViewController.view.rightAnchor),
            self.view.bottomAnchor.constraint(equalTo: hostingViewController.view.bottomAnchor),
            hostingViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
}
