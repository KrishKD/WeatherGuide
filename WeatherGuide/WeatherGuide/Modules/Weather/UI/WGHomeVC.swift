//
//  WGiPhoneHomeVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import MapKit

class WGHomeVC: WGBaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoLocation: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    
    var dataSource: [WGLocation] = []
    var viewModel: WGWeatherViewModel = WGWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewNoLocation.isHidden = true
        btnEdit.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        let locationList = viewModel.retrieveLocationData()
        
        if !locationList.isEmpty {
            self.dataSource = locationList
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        let sourceVC = segue.source
        if let mapVC = sourceVC as? WGLocationMapVC {
            if let latitude = mapVC.pinLocation?.coordinate.latitude,
                let longitude = mapVC.pinLocation?.coordinate.longitude {
                let latString = String(format: "%f", latitude)
                let longString = String(format: "%f", longitude)
                //fetchCurrentWeatherData(forCoordinates: (lat: latString, long: longString))
                fetchCurrentWeatherData(forCoordinates: (lat: latString, long: longString), onCompletion: nil)
            }
        }
    }

    @IBAction func btnEditCick(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        if let button = sender as? UIButton {
            if tableView.isEditing {
                button.setBackgroundImage(UIImage(named: "Done"), for: .normal)
            } else {
                button.setBackgroundImage(UIImage(named: "Edit"), for: .normal)
            }
        }
    }
    
    func fetchCurrentWeatherData(forCoordinates pinLocation: (lat: String, long: String),
                                 onCompletion completionHandler: (() -> Void)?) {
        let params = "lat=\(pinLocation.lat)&lon=\(pinLocation.long)&appid=\(API.key)&units=imperial"
        
        showProgressView()
        viewModel.getCurrentWeatherData(params: params, onSuccess: { (locations) in
            DispatchQueue.main.async {
                self.removeProgressView()
                self.dataSource = locations
                self.tableView.reloadData()
                if let callback = completionHandler {
                    callback()
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.removeProgressView()
                self.showAlert(message: error)
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
        if !self.dataSource.isEmpty {
            viewNoLocation.isHidden = true
            btnEdit.isHidden = false
            return self.dataSource.count
        } else {
            btnEdit.isHidden = true
            viewNoLocation.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationcell = tableView.dequeueReusableCell(withIdentifier: "WGLocationCell", for: indexPath)
        
        if let locationcell = locationcell as? WGLocationCell {
            locationcell.lblCityName.text = dataSource[indexPath.row].weather?.name ?? "NA"
        }
        //locationcell.selectionStyle = .none
        return locationcell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.remove(at: indexPath.row)
            viewModel.removeLocationObject(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let timestamp = dataSource[indexPath.row].timestamp {
            let lastDataReceivedTimeStamp = Int(timestamp)
            let currentTimeInterval = Int(Date().timeIntervalSince1970)
            let difference = currentTimeInterval - lastDataReceivedTimeStamp
            
            if difference > 3600 {
                if let latitude = dataSource[indexPath.row].weather?.coord?.lat,
                    let longitude = dataSource[indexPath.row].weather?.coord?.lon {
                    let latString = String(format: "%f", latitude)
                    let longString = String(format: "%f", longitude)
                    fetchCurrentWeatherData(forCoordinates: (lat: latString, long: longString)) {
                        self.performSegue(withIdentifier: "showWeatherSegue", sender: tableView.cellForRow(at: indexPath))
                    }
                    //fetchCurrentWeatherData(forCoordinates: (lat: latString, long: longString))
                }
            } else {
                performSegue(withIdentifier: "showWeatherSegue", sender: tableView.cellForRow(at: indexPath))
            }
        }
    }
}
