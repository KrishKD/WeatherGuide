//
//  CurrentWeatherViewController.swift
//  WeatherGuide
//
//  Created by krishna on 6/3/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import SwiftUI

class CurrentWeatherViewController: UIViewController {

    let viewModel: CurrentWeatherViewModel
    private lazy var hostingViewController: UIHostingController = {
        let controller: UIHostingController = .init(
            rootView: CurrentWeatherView(viewModel: viewModel)
        )
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(hostingViewController.view)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
