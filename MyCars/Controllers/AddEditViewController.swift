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
    
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btAddEdit.layer.cornerRadius = 6

        
    }
    
    //MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
