//
//  WGProgressView.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/5/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

class WGProgressView: UIView {
    
    static public fileprivate(set) var loadingView: WGProgressView?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //Add round edges to the view
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }
    
    //Class function to display progress view
    static func showProgressView() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        
        if let loadingView = self.loadingView {
            window?.addSubview(loadingView)
        } else {
            let loadingViewNib = UINib.init(nibName: String(describing: WGProgressView.self), bundle: .main)
            let topItems = loadingViewNib.instantiate(withOwner: self, options: nil)
            if !topItems.isEmpty, let loadingView = topItems.first as? WGProgressView {
                WGProgressView.loadingView = loadingView
                
                if let screenCenter = window?.center {
                    loadingView.center = screenCenter
                }
                
                window?.addSubview(loadingView)
            }
        }
    }
    
    //Class function to dismiss progress view
    static func removeProgressView() {
        loadingView?.removeFromSuperview()
    }
}
