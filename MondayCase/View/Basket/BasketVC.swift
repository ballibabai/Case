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
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
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
        let total = CartViewModel.shared.total()
        totalLabel.text = "Total: \(total) ₺"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartViewModel.shared.getItems().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        let item = CartViewModel.shared.getItems()[indexPath.row]
        cell.configure(with: item.car, quantity: item.quantity)
        return cell
    }
    
    @objc func cartUpdated() {
           tableView.reloadData()
           updateTotal()
       }
}

class CartItemCell: UITableViewCell {
    
    var car: Product!
    var quantity: Int = 1
    
    let brandLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let priceLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .systemBlue
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let quantityLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = .systemBlue
            label.textColor = .white
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let minusButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("-", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let plusButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("+", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        
        contentView.addSubview(brandLabel)
               contentView.addSubview(priceLabel)
               contentView.addSubview(minusButton)
               contentView.addSubview(quantityLabel)
               contentView.addSubview(plusButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with car: Product, quantity: Int) {
        self.car = car
        self.quantity = quantity
        brandLabel.text = car.brand
        priceLabel.text = "\(car.price) ₺"
        quantityLabel.text = "\(quantity)"
    }
    
    @objc func decreaseQuantity() {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        if quantity == 0 {
            CartViewModel.shared.removeItem(car)
        } else {
            CartViewModel.shared.updateItem(car, quantity: quantity)
        }
    }
    
    @objc func increaseQuantity() {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        CartViewModel.shared.updateItem(car, quantity: quantity)
    }
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                brandLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                
                priceLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 4),
                priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                
                minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
                minusButton.widthAnchor.constraint(equalToConstant: 30),
                minusButton.heightAnchor.constraint(equalToConstant: 30),
                
                quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                quantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
                quantityLabel.widthAnchor.constraint(equalToConstant: 30),
                quantityLabel.heightAnchor.constraint(equalToConstant: 30),
                
                plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                plusButton.widthAnchor.constraint(equalToConstant: 30),
                plusButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
}
