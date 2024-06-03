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

extension Decimal {
    var intValue: Int {
        NSDecimalNumber(decimal: self).intValue
    }
}

extension String {
    var temperature: AttributedString {
        var attributedString = AttributedString(self)
        attributedString[(attributedString.index(attributedString.endIndex, offsetByCharacters: -2))..<attributedString.endIndex].setAttributes(.init([.baselineOffset : 10.0, .font: UIFont.preferredFont(forTextStyle: .callout)]))
        return attributedString
    }
}

extension Date {
    func toHHmmaString(with formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}

extension UIView {
    func equalToSuperView(constant: CGFloat = 0.0) {
        guard let superview = superview else {
            return
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
            superview.rightAnchor.constraint(equalTo: rightAnchor, constant: constant),
            superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant),
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant)
        ])
    }
}
