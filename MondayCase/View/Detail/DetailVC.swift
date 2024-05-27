//
//  DetailVC.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 26.05.2024.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {
    
    var car: Product?
    
    private let imageView = UIImageView()
    private let brandLabel = UILabel()
    private let detailsLabel = UILabel()
    private let detailsScrollView = UIScrollView()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        configureUI()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissDetailViewController))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = car?.brand
    }
    
    @objc private func dismissDetailViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        brandLabel.font = UIFont.boldSystemFont(ofSize: 24)
        brandLabel.numberOfLines = 0
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        detailsLabel.numberOfLines = 0
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsScrollView.addSubview(detailsLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textColor = .blue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .blue
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(brandLabel)
        view.addSubview(detailsScrollView)
        view.addSubview(priceLabel)
        view.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            brandLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            brandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            detailsScrollView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8),
            detailsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            detailsScrollView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: detailsScrollView.topAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: detailsScrollView.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: detailsScrollView.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: detailsScrollView.bottomAnchor),
            detailsLabel.widthAnchor.constraint(equalTo: detailsScrollView.widthAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: -30),
            
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 120),
            addToCartButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    private func configureUI() {
        guard let car = car else { return }
        imageView.kf.setImage(with: URL(string: car.image))
        brandLabel.text = car.brand
        detailsLabel.text = car.description
        priceLabel.text = "Price: \(car.price) ₺"
    }
    
    @objc func addToCartButtonTapped() {
        guard let car = car else { return }
        BasketViewModel.shared.addItem(car)
        print("Item added to cart: \(car)")
    }
}
