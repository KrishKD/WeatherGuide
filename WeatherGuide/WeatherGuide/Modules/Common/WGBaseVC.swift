//
//  WGBaseVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/5/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

class WGBaseVC: UIViewController {
    
    var progressView: WGProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showProgressView() {
        WGProgressView.showProgressView()
    }
    
    func removeProgressView() {
        WGProgressView.removeProgressView()
    }
}
