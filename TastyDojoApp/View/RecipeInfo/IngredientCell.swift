//
//  IngredientTableViewCell.swift
//  TastyDojoApp
//
//  Created by Михаил on 05.10.2021.
//

import UIKit

final class IngredientCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ingredientIdentifier"
    private let ingredientLabel = UILabel()
    
    //MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ingredientLabel)
        setupLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientLabel.textAlignment = .center
        ingredientLabel.font = .systemFont(ofSize: 13)
        ingredientLabel.numberOfLines = 2
        ingredientLabel.textColor = .gray
        
        NSLayoutConstraint.activate([
            
            ingredientLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            ingredientLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ingredientLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
            ingredientLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 1)
        
        ])
    }
    
    func setupIngredients(ingredient: String) {
        ingredientLabel.text = ingredient
    }
    
}
