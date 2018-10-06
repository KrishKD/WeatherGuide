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

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var viewNoLocation: UIView!
    @IBOutlet private weak var btnEdit: UIButton!
    
    static let dataExpiryTime: Int = 3600 //1 hour
    private var dataSource: [WGLocation] = []
    private var viewModel: WGWeatherViewModel = WGWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewNoLocation.isHidden = true
        btnEdit.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        viewModel.delegate = self
        //Check if there are any archived data
        let locationList = viewModel.retrieveLocationData()
        
        if !locationList.isEmpty {
            self.dataSource = locationList
        }
    }
    
    //Function to handle unwind segue from Map VC
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        let sourceVC = segue.source
        if let mapVC = sourceVC as? WGLocationMapVC {
            if let latitude = mapVC.pinLocation?.coordinate.latitude,
                let longitude = mapVC.pinLocation?.coordinate.longitude {
                let latString = String(format: "%f", latitude)
                let longString = String(format: "%f", longitude)
                fetchCurrentWeatherData(forCoordinates: (lat: latString, long: longString),
                                        onCompletion: nil)
            }
        }
    }

    //Edit tableView rows
    @IBAction func btnEditCick(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        //Change button icon based on tableView edit status
        if let button = sender as? UIButton {
            if tableView.isEditing {
                button.setBackgroundImage(UIImage(named: "Done"), for: .normal)
            } else {
                button.setBackgroundImage(UIImage(named: "Edit"), for: .normal)
            }
        }
    }
    
    //Send params to ViewModel to fetch current weather data
    func fetchCurrentWeatherData(forCoordinates pinLocation: (lat: String, long: String),
                                 onCompletion completionHandler: (() -> Void)?) {
        let params = "lat=\(pinLocation.lat)&lon=\(pinLocation.long)&appid=\(API.key)&units=imperial"
        
        showProgressView()
        viewModel.getCurrentWeatherData(params: params, onSuccess: { (locations) in
            //Refresh UI on main thread
            DispatchQueue.main.async {
                self.removeProgressView()
                self.dataSource = locations
                self.tableView.reloadData()
                if let callback = completionHandler {
                    callback()
                }
            }
        }) { (error) in
            //Remove progressView on main thread and display alert
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

// MARK: - TableView Delegate methods

extension WGHomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Logic to show/hide Edit button and Info text.
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
            locationcell.setupUI(withData: dataSource[indexPath.row].weather?.name ?? "NA") 
        }
        
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
            //Get current time in UTC
            let currentTimeInterval = Int(Date().timeIntervalSince1970)
            let difference = currentTimeInterval - lastDataReceivedTimeStamp
            
            //Request for new weather data if the last received data is stale by an hour
            if difference > 3600 {
                if let latitude = dataSource[indexPath.row].weather?.coord?.lat,
                    let longitude = dataSource[indexPath.row].weather?.coord?.lon {
                    let latString = String(format: "%f", latitude)
                    let longString = String(format: "%f", longitude)
                    fetchCurrentWeatherData(forCoordinates: (lat: latString, long: longString)) {
                        self.performSegue(withIdentifier: "showWeatherSegue", sender: tableView.cellForRow(at: indexPath))
                    }
                }
            } else {
                performSegue(withIdentifier: "showWeatherSegue", sender: tableView.cellForRow(at: indexPath))
            }
        }
    }
}

extension WGHomeVC: WGWeatherViewModelProtocol {
    func dataSaveFailed(errorMsg: String) {
        showAlert(message: errorMsg)
    }
}
