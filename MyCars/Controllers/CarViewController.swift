//
//  CarViewController.swift
//  MyCars
//
//  Created by Danilo Requena on 03/03/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import UIKit
import WebKit

class CarViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGas: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    var car: Car!
    
    //MARK: - super methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        
        let name = (title! + "+" + car.name).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(urlRequest)
    }
    
    //MARK: - Methods
    
    func setupViews() {
        title = car.name
        lbBrand.text = car.brand
        lbGas.text = car.gas
        lbPrice.text = "R$ \(car.price)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
    }

}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
