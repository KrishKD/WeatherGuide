//
//  WGWeatherVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

enum WeatherStatus: String {
    case clearSky = "clear sky"
    case cloudy = "few clouds"
    case scatterredClouds = "scattered clouds"
    case overcastClouds = "overcast clouds"
    case brokenClouds = "broken clouds"
    case shower = "shower rain"
    case rain = "rain"
    case thunderstorm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
}
class WGWeatherVC: UIViewController {

    @IBOutlet private weak var lblCity: UILabel!
    @IBOutlet private weak var lblTemperature: UILabel!
    @IBOutlet private weak var imgWeatherStatus: UIImageView!
    @IBOutlet private var weatherGrid: UICollectionView!
    
    var location: WGLocation?
    let weatherCollectionCellId = "GridWeatherCell"
    var gridDataSource: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let weatherData = location {
            lblCity.text = weatherData.weather?.name
            setWeatherStatusImage()
            lblTemperature.text = "\(Int(weatherData.weather?.main?.temp ?? 0))°"
            setGridDataSource(withData: weatherData.weather)
        }
        
    }
    
    func setGridDataSource(withData weatherData: WGWeatherModel?) {
        self.gridDataSource.append(["Humidity": weatherData?.main?.humidity ?? 0])
        self.gridDataSource.append(["Wind" : Int(weatherData?.wind?.speed ?? 0)])
        
        guard let rain = weatherData?.rain, let snow = weatherData?.snow else {
            return
        }
        self.gridDataSource.append(["Rain" : rain["3h"] ?? 0])
        self.gridDataSource.append(["Snow" : snow["3h"] ?? 0])
        self.weatherGrid.reloadData()
    }
    
    func setWeatherStatusImage() {
        if let weatherDescription = self.location?.weather?.weather?.first?.description {
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
        return CGSize(width: 100.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCollectionCellId, for: indexPath)
        
        if let weatherCell = cell as? WGWeatherGridCell {
            weatherCell.setupUI(withData: gridDataSource[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 100 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let padding = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}
