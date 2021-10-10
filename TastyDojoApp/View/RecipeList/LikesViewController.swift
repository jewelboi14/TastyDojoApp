//
//  LikesViewController.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import UIKit
import Foundation

final class LikesViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let viewModel = RecipeLikesViewModel()
    
    private let backgroundImageView = UIImageView()
    
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
        button.setImage(UIImage(named: "homeIcon"), for: .normal)
        button.setImage(UIImage(named: "homeIcon"), for: .highlighted)
        button.addTarget(self, action: #selector(goToRecipeListTapped), for: .touchUpInside)
        button.backgroundColor = .backgroundLight()
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadRecipeFromData { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
    }

    //MARK: - UI Setup and layout
    
    private func setupUI() {
        
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
        
        navigationItem.setHidesBackButton(true, animated: true)
        navVc.navigationBar.isTranslucent = true
        navVc.navigationBar.barStyle = .black
        navVc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.backgroundLight(),
                                                   NSAttributedString.Key.font: UIFont(name: "Amatic-Bold", size: 26) as Any]
        navigationItem.title = "Saved Recipes"
        
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
    
    //MARK: - CollectionView DataSource and Delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeTitleCell.identifier,
                                                            for: indexPath) as? RecipeTitleCell else { return UICollectionViewCell() }
        let recipe = viewModel.recipes[indexPath.row]
        
        viewModel.loadImageFromData(name: recipe.savedTitle ?? "") { image in
            cell.setupAllInfo(title: recipe.savedTitle ?? "",
                              image: image)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        animateSelectedView(cell)
        let nextVc = RecipeInfoViewController()
        nextVc.isPersistedVC = true
        navigationController?.pushViewController(nextVc, animated: true)
        
        let recipe = viewModel.recipes[indexPath.row]
        
        guard let steps = recipe.savedSteps?.count else { return }
        if steps > 0 {
            for instruction in recipe.savedSteps ?? [] {
                nextVc.addStep(step: instruction)
                }
            }
        
        for ingredient in recipe.savedIngredients ?? [] {
            nextVc.addIngredient(ingredient: ingredient)
        }
        
        viewModel.loadImageFromData(name: recipe.savedTitle ?? "") { image in
            nextVc.setupMajorInfo(title: recipe.savedTitle ?? "",
                                  summary: recipe.savedSummary ?? "",
                                  image: image)
        }
        
    }
   
    //MARK: - Selectors
    
    @objc func goToRecipeListTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        animateSelectedView(sender)
        
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

extension LikesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -50, left: 25, bottom: 50, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width-50, height: collectionView.frame.height*0.65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
}




