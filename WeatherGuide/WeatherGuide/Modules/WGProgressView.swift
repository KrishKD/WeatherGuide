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
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }
    
    static func showProgressView() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        
        if let loadingView = self.loadingView {
            window?.addSubview(loadingView)
        } else {
            let loadingViewNib = UINib.init(nibName: String(describing: WGProgressView.self), bundle: .main)
            let topItems = loadingViewNib.instantiate(withOwner: self, options: nil)
            if topItems.isEmpty == false, let loadingView = topItems[0] as? WGProgressView {
                WGProgressView.loadingView = loadingView
                
                if let screenCenter = window?.center {
                    loadingView.center = screenCenter
                }
                
                window?.addSubview(loadingView)
            }
        }
    }
    
    static func removeProgressView() {
        loadingView?.removeFromSuperview()
    }
}
