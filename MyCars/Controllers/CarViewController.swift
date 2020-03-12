//
//  CarViewController.swift
//  MyCars
//
//  Created by Danilo Requena on 03/03/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGas: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    //MARK: - Properties
    
    var car: Car!
    
    //MARK: - super methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
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
