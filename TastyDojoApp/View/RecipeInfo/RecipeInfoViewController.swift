//
//  RecipeInfoViewController.swift
//  TastyDojoApp
//
//  Created by Михаил on 05.10.2021.
//

import UIKit

final class RecipeInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    var isPersistedVC = false
    
    private var ingredients: [String] = []
    private var steps: [String] = []
    private var viewModel = RecipeInfoViewModel()
    
    private let recipeInfoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .backgroundLight()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let canvasView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.rgb(red: 0, green: 0, blue: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.45
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .gray
        label.font = UIFont(name: "Amatic-Bold", size: 30)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .mainPiggie()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont(name: "Amatic-Bold", size: 30)
        label.text = "ingredients:"
        return label
    }()
    
    private let ingredientsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 20
        tv.rowHeight = 40
        return tv
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont(name: "Amatic-Bold", size: 30)
        label.text = "cooking instructions:"
        return label
    }()
    
    private let scrollHintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont(name: "Amatic-Bold", size: 20)
        label.text = "(scroll to see more)"
        return label
    }()
    
    private let stepsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 70
        tv.backgroundColor = .backgroundLight()
        tv.layer.borderColor = UIColor.mainPiggie().cgColor
        tv.layer.borderWidth = 3
        tv.layer.cornerRadius = 14
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private let bonAppetitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont(name: "Amatic-Bold", size: 30)
        label.text = "BON APPETIT!"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        ingredientsTableView.register(IngredientCell.self,
                                      forCellReuseIdentifier: IngredientCell.identifier)
        ingredientsTableView.dataSource = self
        
        stepsTableView.register(StepCell.self, forCellReuseIdentifier: StepCell.identifier)
        stepsTableView.dataSource = self
        stepsTableView.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let contentRect: CGRect = recipeInfoScrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        recipeInfoScrollView.contentSize = contentRect.size
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.steps = []
        viewModel.ingredients = []
    }
    

    //MARK: - UI Setup and layout
    
    private func setupUI() {
        
        //navigation VC setup
        
        guard let navVc = navigationController else { return }
        navVc.navigationBar.isTranslucent = true
        navVc.navigationBar.tintColor = .backgroundLightDarker()
        navVc.navigationBar.barTintColor = .mainPiggie()
        if isPersistedVC == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save recipe",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(saveTapped))
        }
        
        //view hierarchy
        
        titleView.addSubview(titleLabel)
        imageContainerView.addSubview(recipeImageView)
        descriptionContainerView.addSubview(descriptionLabel)
        
        canvasView.addSubview(titleView)
        canvasView.addSubview(imageContainerView)
        canvasView.addSubview(descriptionContainerView)
        canvasView.addSubview(ingredientsLabel)
        canvasView.addSubview(ingredientsTableView)
        canvasView.addSubview(instructionsLabel)
        canvasView.addSubview(stepsTableView)
        canvasView.addSubview(bonAppetitLabel)
        canvasView.addSubview(scrollHintLabel)
        
        recipeInfoScrollView.addSubview(canvasView)
        
        view.addSubview(recipeInfoScrollView)
        
        NSLayoutConstraint.activate([
            
            recipeInfoScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            recipeInfoScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            recipeInfoScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            recipeInfoScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            canvasView.widthAnchor.constraint(equalTo: recipeInfoScrollView.widthAnchor),
            canvasView.centerXAnchor.constraint(equalTo: recipeInfoScrollView.centerXAnchor),
            canvasView.topAnchor.constraint(equalTo: recipeInfoScrollView.topAnchor),
            
            //recipe image
            
            recipeImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            recipeImageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor),
            recipeImageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor),
            
            imageContainerView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            imageContainerView.topAnchor.constraint(equalTo: canvasView.topAnchor, constant: 40),
            imageContainerView.heightAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.7),
            imageContainerView.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.7),
            
            //title label
            
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 5),
            
            titleView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 30),
            titleView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            titleView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.3),
            titleView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            //description label
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: descriptionContainerView.rightAnchor, constant: -5),
            descriptionLabel.leftAnchor.constraint(equalTo: descriptionContainerView.leftAnchor, constant: 5),
            
            descriptionContainerView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            descriptionContainerView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            descriptionContainerView.heightAnchor.constraint(equalTo: descriptionLabel.heightAnchor, multiplier: 1.1),
            descriptionContainerView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            //ingredients
            
            ingredientsLabel.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: 15),
            ingredientsLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            ingredientsLabel.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.3),
            ingredientsLabel.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            ingredientsTableView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 15),
            ingredientsTableView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            ingredientsTableView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            ingredientsTableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.ingredients.count*40)),
            
            instructionsLabel.topAnchor.constraint(equalTo: ingredientsTableView.bottomAnchor, constant: 15),
            instructionsLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            instructionsLabel.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.2),
            instructionsLabel.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            scrollHintLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 5),
            scrollHintLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            scrollHintLabel.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.1),
            scrollHintLabel.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            stepsTableView.topAnchor.constraint(equalTo: scrollHintLabel.bottomAnchor, constant: 15),
            stepsTableView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            stepsTableView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            stepsTableView.heightAnchor.constraint(equalToConstant: 300),
            
            bonAppetitLabel.topAnchor.constraint(equalTo: stepsTableView.bottomAnchor, constant: 15),
            bonAppetitLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            bonAppetitLabel.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.3),
            bonAppetitLabel.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            bonAppetitLabel.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor)
            
        ])
        
    }
    
    //MARK: - Fill with info
    
    func addStep(step: String) {
        viewModel.steps.append(step)
    }
    
    func addIngredient(ingredient: String) {
        viewModel.ingredients.append(ingredient)
    }
    
    func setupMajorInfo(title: String, summary: String, image: UIImage) {
        titleLabel.text = title
        descriptionLabel.text = summary
        recipeImageView.image = image
    }
    
    //MARK: - Selectors
    
    @objc func saveTapped() {
        
        viewModel.saveInfo(title: titleLabel.text ?? "",
                           summary: descriptionLabel.text ?? "",
                           ingredients: viewModel.ingredients,
                           steps: viewModel.steps) { success in
            if success {
                navigationItem.rightBarButtonItem?.title = "Success!"
            } else {
                navigationItem.rightBarButtonItem?.title = "Something went wrong :("
            }
        }
        viewModel.saveImage(title: titleLabel.text ?? "",
                                           image: recipeImageView.image ?? UIImage())

    }
    
}

//MARK: - UITableViewDataSource

extension RecipeInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == ingredientsTableView {
            return viewModel.ingredients.count
        } else {
            return viewModel.steps.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == ingredientsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier) as? IngredientCell else {
                return UITableViewCell()
            }
            cell.setupIngredients(ingredient: viewModel.ingredients[indexPath.row])
            cell.selectionStyle = .none
            cell.backgroundColor = .mainPiggie()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StepCell.identifier) as? StepCell else {
                return UITableViewCell()
            }
                cell.setupStep(step: indexPath.row + 1, stepText: viewModel.steps[indexPath.row])
                cell.selectionStyle = .none
                cell.backgroundColor = .backgroundLight()
                return cell
        }
        
    }
    
}

//MARK: - UITableViewDelegate

extension RecipeInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}





