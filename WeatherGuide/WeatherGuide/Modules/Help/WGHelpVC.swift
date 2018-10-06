//
//  HelpVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/5/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import WebKit

class WGHelpVC: UIViewController {

    @IBOutlet weak var webContainerView: UIView!
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.webContainerView.frame.size.height))
        self.webView = WKWebView(frame: customFrame)
        webView?.backgroundColor = .clear
        webView?.translatesAutoresizingMaskIntoConstraints = false
        if let web = webView {
            self.webContainerView.addSubview(web)
        }
        if let webView = self.webView {
            self.webContainerView.addSubview(webView)
            webView.topAnchor.constraint(equalTo: webContainerView.topAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: webContainerView.rightAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: webContainerView.leftAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: webContainerView.bottomAnchor).isActive = true
            webView.heightAnchor.constraint(equalTo: webContainerView.heightAnchor).isActive = true
        }
        
        loadRequest()
    }
    
    func loadRequest() {
        
        if let url = Bundle.main.url(forResource: "Help", withExtension: "html", subdirectory: "WebFiles") {
            webView?.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    @IBAction func btnCloseClick(_ sender: Any) {
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
