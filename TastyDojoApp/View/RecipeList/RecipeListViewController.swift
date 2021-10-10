//
//  RecipeListViewController.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import UIKit
import Foundation

final class RecipeListViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let backgroundImageView = UIImageView()
    private let viewModel = RecipeListViewModel()
    private var cellLayoutTriggered = false
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .backgroundLight()
        searchBar.searchTextField.textColor = .gray
        searchBar.searchTextField.tintColor = .gray
        searchBar.searchTextField.backgroundColor = .backgroundLight()
        searchBar.tintColor = .backgroundLight()
        return searchBar
    }()
    
    private let favouritesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "favouritesIcon"), for: .normal)
        button.setImage(UIImage(named: "favouritesIcon"), for: .highlighted)
        button.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        button.backgroundColor = .backgroundLight()
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let likesLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.fetchRecipeInfo(query: "") { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - UI Setup and layout
    
    private func setupUI() {
        
        //Background setup
        
        backgroundImageView.image = UIImage(named: "background")
        collectionView.backgroundView = backgroundImageView
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(RecipeTitleCell.self,
                                forCellWithReuseIdentifier: RecipeTitleCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = .mainPiggie()
        collectionView.isPagingEnabled = true
        view.addSubview(favouritesButton)
        
        //Nav Bar
        
        guard let navVc = navigationController else { return }
        
        navVc.navigationBar.isTranslucent = true
        setDefaultNavBarItems()
        navVc.navigationBar.barStyle = .black
        navVc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.backgroundLight(),
                                                   NSAttributedString.Key.font: UIFont(name: "Amatic-Bold", size: 26) as Any]
        navigationItem.title = "Recipes Dojo"
        
        //Bottom bar layout
        
        NSLayoutConstraint.activate([
            
            favouritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouritesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            favouritesButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            favouritesButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
    }
    
    //DRY function
    
    private func setDefaultNavBarItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .backgroundLight()
        
    }
    
    //MARK: - CollectionView DataSource and Delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeTitleCell.identifier,
                                                            for: indexPath) as? RecipeTitleCell else { return UICollectionViewCell() }
        
        let recipe = viewModel.recipes[indexPath.row]
        cell.setupBottomView(health: recipe.veryHealthy, vegan: recipe.vegan)
        
        viewModel.fetchRecipeImage(url: recipe.image) { image in
            cell.setupAllInfo(title: recipe.title, image: image)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard indexPath.row == viewModel.recipes.count - 3 else { return }
        viewModel.fetchMoreRecipes { recipes in
            self.collectionView.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        animateSelectedView(cell)
        let nextVc = RecipeInfoViewController()
        navigationController?.pushViewController(nextVc, animated: true)
        
        let recipe = viewModel.recipes[indexPath.row]
        
        if recipe.analyzedInstructions.count > 0 {
            for instruction in recipe.analyzedInstructions[0].steps {
                nextVc.addStep(step: instruction.step)
            }
        }
        
        for ingredient in recipe.extendedIngredients {
            nextVc.addIngredient(ingredient: ingredient.original)
        }
        
        viewModel.fetchRecipeImage(url: recipe.image) { image in
            nextVc.setupMajorInfo(title: recipe.title,
                                  summary: recipe.summary,
                                  image: image)
        }
        
    }
    
    //MARK: - Selectors
    
    @objc func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        searchBar.showsCancelButton = true
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    @objc func favouritesButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(LikesViewController(collectionViewLayout: likesLayout), animated: true)
        animateSelectedView(sender)
    }
    
    @objc func keyboardWillAppear() {
        cellLayoutTriggered = true
    }
    
    @objc func keyboardWillDisappear() {
        cellLayoutTriggered = false
    }
    
    //MARK: - View spring animation method
    
    private func animateSelectedView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
        { _ in
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn,
                           animations: {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
                           completion: nil)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecipeListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return cellLayoutTriggered
        ? UIEdgeInsets(top: -5, left: 25, bottom: 5, right: 25)
        : UIEdgeInsets(top: -50, left: 25, bottom: 50, right: 25)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellLayoutTriggered
        ? CGSize(width: collectionView.frame.width-50, height: collectionView.frame.height*0.46)
        : CGSize(width: collectionView.frame.width-50, height: collectionView.frame.height*0.65)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
}

//MARK: - UISearchBarDelegate

extension RecipeListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        navigationItem.titleView = nil
        setDefaultNavBarItems()
        viewModel.fetchRecipeInfo(query: "") { [weak self] recipes in
            self?.collectionView.reloadData()
            self?.collectionView.contentOffset.x = 0
        }
        viewModel.query = ""
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.fetchRecipeInfo(query: searchText) { [weak self] recipes in
            self?.collectionView.reloadData()
            self?.collectionView.contentOffset.x = 0
        }
        viewModel.query = searchText
    }
    
}

