//
//  WGWeatherVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

class WGWeatherVC: WGBaseVC {

    @IBOutlet private weak var lblCity: UILabel!
    @IBOutlet private weak var lblTemperature: UILabel!
    @IBOutlet private weak var imgWeatherStatus: UIImageView!
    @IBOutlet private var weatherGrid: UICollectionView!
    
    var location: WGLocation?
    private let weatherCollectionCellId = "GridWeatherCell"
    private var gridDataSource: [[String: String]] = []
    
    private let collectionCellWidth: CGFloat = 95
    private let collectionCellHeight: CGFloat = 60
    private let collectionCellPadding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let weatherData = location {
            lblCity.text = weatherData.weather?.name
            
            //Get image based on weather condition status
            let imageName = WGUtils.setWeatherStatusImage(weatherCondition: self.location?.weather?.weather?.first?.main)
            imgWeatherStatus.image = UIImage(named: imageName)

            //Set Attribute string to Temperature label
            lblTemperature.attributedText = getAttributedStrForTempLbl(weatherData)
            
            //Setup collectionView data source
            setGridDataSource(withData: weatherData.weather)
        }
    }
    
    func setGridDataSource(withData weatherData: WGWeatherModel?) {
        if let humidityValue = weatherData?.main?.humidity, let speed = weatherData?.wind?.speed {
            self.gridDataSource.append(["Humidity": "\(humidityValue)%"])
            self.gridDataSource.append(["Wind" : "\(Int(speed))mph"])
        }
        
        if let rain = weatherData?.rain, let value = rain["3h"] {
            self.gridDataSource.append(["ShowerRain" : "\(value)"])
        }
        
        if let snow = weatherData?.snow, let value = snow["3h"] {
            self.gridDataSource.append(["Snow" : "\(value)"])
        }
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Format temperature string
    func getAttributedStrForTempLbl(_ weatherData: WGLocation) -> NSMutableAttributedString {
        //Set font size
        let tempAttributedString = NSMutableAttributedString(string: "\(Int(weatherData.weather?.main?.temp ?? 0))°F", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70.0)])
        
        //Setup superscript attribute
        let superScriptAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40.0), NSAttributedString.Key.baselineOffset: 20]
        
        //Add superscript attribute to last 2 characters
        tempAttributedString.setAttributes(superScriptAttributes, range: NSMakeRange(tempAttributedString.length - 2, 2))
        
        return tempAttributedString
    }
}

extension WGWeatherVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCollectionCellId, for: indexPath)
        
        if let weatherCell = cell as? WGWeatherGridCell {
            weatherCell.setupUI(withData: gridDataSource[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = Int(collectionCellWidth) * collectionView.numberOfItems(inSection: 0)
        let totalCellHeight = Int(collectionCellHeight) * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = Int(collectionCellPadding) * (collectionView.numberOfItems(inSection: 0) - 1)
        let totalSpacingHeight = Int(collectionCellPadding) * (collectionView.numberOfItems(inSection: 0) - 1)
        
        //For landscape orientation set padding to top & bottom
        if UIDevice.current.orientation.isLandscape {
            let padding = (collectionView.layer.frame.size.height - CGFloat(totalCellHeight + totalSpacingHeight)) / 2
            return UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        }
        
        //For Portrait orientation set padding to right & left
        let padding = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}
