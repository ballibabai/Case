//
//  CustomCollectionViewCell.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 25.05.2024.
//

import UIKit
import Kingfisher

protocol HomeCollectionViewCellDelegate: AnyObject {
    func didTapAddToCartButton(car: Product)
    func didTapFavoriteButton(car: Product)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    var car: Product?
    weak var delegate: HomeCollectionViewCellDelegate?
    
    let favoriteImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Star"))
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(favoriteImage)
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteImage.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            favoriteImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteImage.widthAnchor.constraint(equalToConstant: 24),
            favoriteImage.heightAnchor.constraint(equalToConstant: 24),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            brandLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            addToCartButton.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 44),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func favoriteButtonTapped() {
        guard let car = car else { return }
        delegate?.didTapFavoriteButton(car: car)
    }
    
    @objc func addToCartButtonTapped() {
        guard let car = car else { return }
        delegate?.didTapAddToCartButton(car: car)
    }
    
    func configure(with imageUrl: String, price: String, brand: String) {
        imageView.kf.setImage(with: URL(string: imageUrl))
        priceLabel.text = "\(price) ₺"
        brandLabel.text = brand
    }
    func configuree(car: Product, isFavorite: Bool) {
        self.car = car
        favoriteImage.image = UIImage(named: isFavorite ? "Starr" : "Star")
    }
}
