//
//  WGExtensions.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/6/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

protocol ShowAlert {}

extension ShowAlert where Self: UIViewController {
    func showAlert(title: String? = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: ShowAlert {}
