//
//  FilterVC.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 27.05.2024.
//

import UIKit

protocol FilterVCDelegate: AnyObject {
    func didApplyFilter(brand: String?)
}

class FilterVC: UIViewController {
    
    weak var delegate: FilterVCDelegate?
    
    var brandTextField: UITextField!
    var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Select Filter"
        
        brandTextField = UITextField()
        brandTextField.placeholder = "Brand"
        brandTextField.borderStyle = .roundedRect
        brandTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandTextField)
        
        applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            brandTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            brandTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            applyButton.topAnchor.constraint(equalTo: brandTextField.bottomAnchor, constant: 20),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 100),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func applyFilter() {
        let brand = brandTextField.text
        
        delegate?.didApplyFilter(brand: brand)
        dismiss(animated: true, completion: nil)
    }
}

