//
//  WGiPhoneHomeVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

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
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        let sourceVC = segue.source
        if let mapVC = sourceVC as? WGLocationMapVC {
            if let lat = mapVC.pinLocation?.coordinate.latitude,
                let longitude = mapVC.pinLocation?.coordinate.longitude {
                let latString = String(format: "%f", lat)
                let longString = String(format: "%f", longitude)
                
                let params = "lat=\(latString)&lon=\(longString)&appid=\(API.key)&units=metric"
                showProgressView()
                viewModel.getCurrentWeatherData(params: params, onSuccess: { (location) in
                    DispatchQueue.main.async {
                        self.removeProgressView()
                        self.dataSource.append(location)
                        self.tableView.reloadData()
                    }
                }) { (error) in
                    //Display error
                }
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
            locationcell.lblCityName.text = dataSource[indexPath.row].weather?.name
        }
        //locationcell.selectionStyle = .none
        return locationcell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
