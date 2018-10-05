//
//  WGiPhoneHomeVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

class WGHomeVC: UIViewController {

    var dataSource: [WGLocation] = []
    var viewModel: WGWeatherViewModel = WGWeatherViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //registerCell()
    }
    
    func registerCell() {
        let nib = UINib(nibName: "WGLocationcell", bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: "WGLocationcell")
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        let sourceVC = segue.source
        if let mapVC = sourceVC as? WGLocationMapVC {
            if let lat = mapVC.pinLocation?.coordinate.latitude,
                let longitude = mapVC.pinLocation?.coordinate.longitude {
                let latString = String(format: "%f", lat)
                let longString = String(format: "%f", longitude)
                
                let params = "lat=\(latString)&lon=\(longString)&appid=\(API.key)&units=metric"
                
                viewModel.getCurrentWeatherData(params: params, onSuccess: { (location) in
                    
                    DispatchQueue.main.async {
                        self.dataSource.append(location)
                        self.tableView.reloadData()
                    }
                }) { (error) in
                    //Display error
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showWeatherSegue", let destinationVC = segue.destination as? WGWeatherVC {
            if let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell)
            {
                destinationVC.location = self.dataSource[indexPath.row]
            }
        }
    }
}

extension WGHomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationcell = tableView.dequeueReusableCell(withIdentifier: "WGLocationCell", for: indexPath)
        
        if let locationcell = locationcell as? WGLocationCell {
            locationcell.lblCityName.text = dataSource[indexPath.row].weather?.name
        }
        
        return locationcell
    }
}
