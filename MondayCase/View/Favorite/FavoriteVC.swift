//
//  FavoriteVC.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 27.05.2024.
//

import UIKit

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
       var favoriteCars: [Product] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           
           view.backgroundColor = .white
           title = "Favorites"
           
           tableView = UITableView(frame: .zero)
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(FavoriteItemCell.self, forCellReuseIdentifier: "FavoriteCell")
           tableView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(tableView)
           
           setupConstraints()
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           loadFavorites()
           tableView.reloadData()
       }

       func setupConstraints() {
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }
       
       func loadFavorites() {
           favoriteCars = FavoriteViewModel.shared.getFavoriteCars()
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return favoriteCars.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteItemCell
           let car = favoriteCars[indexPath.row]
           cell.configure(with: car)
           return cell
       }

}

class FavoriteItemCell: UITableViewCell {
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(brandLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            brandLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with car: Product) {
        brandLabel.text = car.brand
        priceLabel.text = "\(car.price) ₺"
    }
}
