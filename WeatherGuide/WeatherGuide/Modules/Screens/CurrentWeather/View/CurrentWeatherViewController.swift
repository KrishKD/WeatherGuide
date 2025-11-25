//
//  CurrentWeatherViewController.swift
//  WeatherGuide
//
//  Created by krishna on 6/3/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class CurrentWeatherViewController: UIViewController {

    @ObservedObject var viewModel: CurrentWeatherViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var hostingViewController: UIHostingController = {
        let controller: UIHostingController = .init(
            rootView: CurrentWeatherView(viewModel: viewModel)
        )
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = UIColor(named: "Base")
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.navigationTitle
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(named: "Base")
        addChild(hostingViewController)
        view.addSubview(hostingViewController.view)
        hostingViewController.didMove(toParent: self)
    }
    
    // MARK: - Initializer
    
    init(viewModel: CurrentWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
