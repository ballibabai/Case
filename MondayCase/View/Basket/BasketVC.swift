//
//  BasketVC.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 26.05.2024.
//

import UIKit

class BasketVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Basket"
        
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(BasketItemCell.self, forCellReuseIdentifier: "BasketItemCell")
        view.addSubview(tableView)
        
        totalLabel = UILabel()
        totalLabel.textAlignment = .center
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(totalLabel)
        
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),
            
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func updateTotal() {
        let total = BasketViewModel.shared.total()
        totalLabel.text = "Total: \(total) ₺"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BasketViewModel.shared.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketItemCell", for: indexPath) as! BasketItemCell
        let item = BasketViewModel.shared.getItems()[indexPath.row]
        cell.configure(with: item.car, quantity: item.quantity)
        return cell
    }
    
    @objc func cartUpdated() {
        tableView.reloadData()
        updateTotal()
    }
}
