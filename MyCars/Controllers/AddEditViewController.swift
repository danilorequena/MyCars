//
//  AddEditViewController.swift
//  MyCars
//
//  Created by Danilo Requena on 03/03/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    var car: Car!
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btAddEdit.layer.cornerRadius = 6

        
    }
    
    //MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        if car == nil {
            car = Car()
        }
        car.name = tfName.text!
        car.brand = tfBrand.text!
        if  tfPrice.text!.isEmpty {tfPrice.text = "0"}
        car.price = Double(tfPrice.text!)!
        car.gasType = scGasType.selectedSegmentIndex
        
        REST.save(car: car) { (success) in
            self.goBack()
        }
    }
    
    //MARK: - Methods
    
    func goBack() {
        DispatchQueue.main.async {
//            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
