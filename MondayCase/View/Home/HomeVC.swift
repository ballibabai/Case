//
//  HomeVC.swift
//  MondayCase
//
//  Created by İbrahim Ballıbaba on 25.05.2024.
//

import UIKit

class HomeVC: UIViewController, UITextFieldDelegate {
    
    var viewModel = HomeViewModel()
    var collectionView: UICollectionView!
    var searchTextField = UITextField()
    var filtersLabel = UILabel()
    var selectFilterButton = UIButton()
    var favoriteCars: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchTextField()
        setupLabel()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchCars()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: NSNotification.Name("FavoritesChanged"), object: nil)
    }
    
    @objc func reloadFavorites() {
        collectionView.reloadData()
    }
}

extension HomeVC {
    
    func setupLabel() {
        
        filtersLabel.text = "Filters:"
        filtersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersLabel)
        
        selectFilterButton = UIButton(type: .system)
        selectFilterButton.setTitle("Select Filter", for: .normal)
        selectFilterButton.setTitleColor(.black, for: .normal)
        selectFilterButton.backgroundColor = .lightGray
        selectFilterButton.layer.cornerRadius = 5
        selectFilterButton.addTarget(self, action: #selector(selectFilterTapped), for: .touchUpInside)
        selectFilterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectFilterButton)
    }
    
    func setupSearchTextField() {
        searchTextField.placeholder = "Search"
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.tintColor = .gray
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        searchTextField.leftView = searchIcon
        searchTextField.leftViewMode = .always
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(searchTextField)
    }
    
    @objc func selectFilterTapped() {
        let filterVC = FilterVC()
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let titleLabel = UILabel()
        titleLabel.text = "E-Market"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.italicSystemFont(ofSize: 20)
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftItem
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            filtersLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            filtersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            selectFilterButton.centerYAnchor.constraint(equalTo: filtersLabel.centerYAnchor),
            selectFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            selectFilterButton.widthAnchor.constraint(equalToConstant: 120),
            selectFilterButton.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        viewModel.filterCars(with: searchText)
    }
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeVC: HomeCollectionViewCellDelegate {
    func didTapFavoriteButton(car: Product) {
        if FavoriteViewModel.shared.isFavorite(car: car) {
            FavoriteViewModel.shared.removeFavorite(car: car)
        } else {
            FavoriteViewModel.shared.addFavorite(car: car)
        }
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesChanged"), object: nil)
        collectionView.reloadData()
    }
    
    func didTapAddToCartButton(car: Product) {
        BasketViewModel.shared.addItem(car)
    }
}


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCars()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! HomeCollectionViewCell
        let car = viewModel.car(at: indexPath.row)
        cell.configure(with: car.image, price: car.price, brand: car.brand)
        let isFavorite = FavoriteViewModel.shared.isFavorite(car: car)
        cell.configuree(car: car, isFavorite: isFavorite)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 30) / 2
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let car = viewModel.car(at: indexPath.row)
        let detailVC = DetailVC()
        detailVC.car = car
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeVC: FilterVCDelegate {
    func didApplyFilter(brand: String?) {
        print("Filter applied: Brand - \(brand ?? "")")
        viewModel.filterProducts(searchText: nil, brand: brand)
        collectionView.reloadData()
    }
}
