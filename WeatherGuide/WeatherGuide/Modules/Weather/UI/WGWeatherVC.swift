//
//  WGWeatherVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

enum WeatherStatus: String {
    case clearSky = "Clear"
    case cloudy = "Clouds"
    case scatterredClouds = "scattered clouds"
    case overcastClouds = "overcast clouds"
    case brokenClouds = "broken clouds"
    case shower = "shower rain"
    case rain = "Rain"
    case thunderstorm = "thunderstorm"
    case snow = "Snow"
    case mist = "Mist"
}
class WGWeatherVC: WGBaseVC {

    @IBOutlet private weak var lblCity: UILabel!
    @IBOutlet private weak var lblTemperature: UILabel!
    @IBOutlet private weak var imgWeatherStatus: UIImageView!
    @IBOutlet private var weatherGrid: UICollectionView!
    
    var location: WGLocation?
    let weatherCollectionCellId = "GridWeatherCell"
    var gridDataSource: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let weatherData = location {
            lblCity.text = weatherData.weather?.name
            setWeatherStatusImage()

            // set attributed text on temperature label
            let superScriptAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40.0), NSAttributedString.Key.baselineOffset: 20]
            let tempAttributedString = NSMutableAttributedString(string: "\(Int(weatherData.weather?.main?.temp ?? 0))°F", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70.0)])
            tempAttributedString.setAttributes(superScriptAttributes, range: NSMakeRange(tempAttributedString.length - 2, 2))
            
            lblTemperature.attributedText = tempAttributedString
            
            setGridDataSource(withData: weatherData.weather)
        }
    }
    
    func setGridDataSource(withData weatherData: WGWeatherModel?) {
        
        if let humidityValue = weatherData?.main?.humidity, let speed = weatherData?.wind?.speed {
            self.gridDataSource.append(["Humidity": "\(humidityValue)%"])
            self.gridDataSource.append(["Wind" : "\(Int(speed))mph"])
            //self.gridDataSource.append(["ShowerRain" : "3m"])
        }
        
        if let rain = weatherData?.rain, let value = rain["3h"] {
            self.gridDataSource.append(["ShowerRain" : "\(value)"])
        }
        
        if let snow = weatherData?.snow, let value = snow["3h"] {
            self.gridDataSource.append(["Snow" : "\(value)"])
        }
    }
    
    func setWeatherStatusImage() {
        if let weatherDescription = self.location?.weather?.weather?.first?.main {
            var imageName = ""
            switch weatherDescription {
            case WeatherStatus.clearSky.rawValue:
                imageName = "ClearSky"
            case WeatherStatus.cloudy.rawValue:
                imageName = "PartlyCloudy"
            case WeatherStatus.scatterredClouds.rawValue:
                imageName = "ScatteredClouds"
            case WeatherStatus.overcastClouds.rawValue:
                imageName = "BrokenClouds"
            case WeatherStatus.brokenClouds.rawValue:
                imageName = "BrokenClouds"
            case WeatherStatus.shower.rawValue:
                imageName = "ShowerRain"
            case WeatherStatus.rain.rawValue:
                imageName = "Rain"
            case WeatherStatus.thunderstorm.rawValue:
                imageName = "Thunderstorm"
            case WeatherStatus.snow.rawValue:
                imageName = "Snow"
            case WeatherStatus.mist.rawValue:
                imageName = "Mist"
            default:
                imageName = "ScatteredClouds"
            }
            imgWeatherStatus.image = UIImage(named: imageName)
        }
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension WGWeatherVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCollectionCellId, for: indexPath)
        
        if let weatherCell = cell as? WGWeatherGridCell {
            weatherCell.setupUI(withData: gridDataSource[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 95 * collectionView.numberOfItems(inSection: 0)
        let totalCellHeight = 60 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        if UIDevice.current.orientation.isLandscape {
            let padding = (collectionView.layer.frame.size.height - CGFloat(totalCellHeight + totalSpacingWidth)) / 2
            return UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        }
        
        let padding = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}
