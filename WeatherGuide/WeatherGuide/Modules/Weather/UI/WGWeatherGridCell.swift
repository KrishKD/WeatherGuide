//
//  WGWeatherGridCellCollectionViewCell.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

class WGWeatherGridCell: UICollectionViewCell {

    @IBOutlet private weak var imgCondition: UIImageView!
    @IBOutlet private weak var lblData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(withData data: [String: Any]) {
        if let key = data.keys.first, let value = data[key] {
            imgCondition.image = UIImage(named: key)
            lblData.text = "\(value)"
        }
    }

}
