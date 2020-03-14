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
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    var car: Car!
    var brands: [Brand] = []
    lazy var pickerView: UIPickerView = {
       let pickerview = UIPickerView()
        pickerview.backgroundColor = .white
        pickerview.delegate = self
        pickerview.dataSource = self
        return pickerview
    }()
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btAddEdit.layer.cornerRadius = 6
        checkContainsCar()
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolBar.tintColor = #colorLiteral(red: 0.00400000019, green: 0.7179999948, blue: 0.8899999857, alpha: 1)
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.items = [btCancel, btSpace, btDone]
        tfName.inputAccessoryView = toolBar
        tfName.inputView = pickerView
        
        loadBrands()

    }
    
    //MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
        if car == nil {
            car = Car()
        }
        car.name = tfBrand.text!
        car.brand = tfName.text!
        if  tfPrice.text!.isEmpty {tfPrice.text = "0"}
        car.price = Double(tfPrice.text!)!
        car.gasType = scGasType.selectedSegmentIndex
        
        if car._id == nil {
            REST.save(car: car) { (success) in
                self.goBack()
            }
        } else {
            REST.update(car: car) { (success) in
                self.goBack()
            }
        }
       
    }
    
    //MARK: - Methods
    
    func loadBrands() {
        REST.loadBrands { (brands) in
            if let brands = brands {
                self.brands = brands.sorted(by: {$0.fipe_name < $1.fipe_name})
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkContainsCar() {
        if car != nil {
            tfName.text = car.brand
            tfBrand.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    }
    
    @objc func cancel() {
        tfName.resignFirstResponder()
    }
    
    @objc func done() {
        tfName.text = brands[pickerView.selectedRow(inComponent: 0)].fipe_name
        tfName.resignFirstResponder()
    }
    
    @IBAction func btCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.fipe_name
    }
}
