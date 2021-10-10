//
//  RecipeTitleCell.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import Foundation
import UIKit

final class RecipeTitleCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "identifier"
    
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
    
    //Bottom advantages list
    
    private let advantagesView = UIView()
    
    private let firstAdvImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let secondAdvImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI Building
    
    private func setupUI() {
        
        contentView.backgroundColor = .backgroundLight()
        
        //Add subview
        
        imageContainerView.addSubview(recipeImageView)
        titleView.addSubview(titleLabel)
        advantagesView.addSubview(firstAdvImageView)
        advantagesView.addSubview(secondAdvImageView)
        contentView.addSubview(imageContainerView)
        contentView.addSubview(titleView)
        contentView.addSubview(advantagesView)
        
        firstAdvImageView.translatesAutoresizingMaskIntoConstraints = false
        secondAdvImageView.translatesAutoresizingMaskIntoConstraints = false
        advantagesView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Layouts
        
        NSLayoutConstraint.activate([
            
            //ImageView
            
            imageContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            imageContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            imageContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            
            recipeImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            recipeImageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor),
            recipeImageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor),
            
            //TitleView
            
            titleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -10),
            titleView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            titleView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 5),
            
            //bottom advantages list
            
            advantagesView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            advantagesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            advantagesView.heightAnchor.constraint(equalToConstant: 90),
            advantagesView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            
            firstAdvImageView.widthAnchor.constraint(equalTo: advantagesView.widthAnchor, multiplier: 0.33),
            firstAdvImageView.heightAnchor.constraint(equalTo: advantagesView.heightAnchor),
            firstAdvImageView.leftAnchor.constraint(equalTo: advantagesView.leftAnchor),
            
            secondAdvImageView.widthAnchor.constraint(equalTo: advantagesView.widthAnchor, multiplier: 0.33),
            secondAdvImageView.heightAnchor.constraint(equalTo: advantagesView.heightAnchor),
            secondAdvImageView.centerXAnchor.constraint(equalTo: advantagesView.centerXAnchor)
            
        ])
    }
    
    func setupAllInfo(title: String, image: UIImage) {
        recipeImageView.image = image
        titleLabel.text = title
    }
    
    func setupBottomView(health: Bool, vegan: Bool) {
        
        if let healthImage = UIImage(named: "healthIcon"),
           let veganImage = UIImage(named: "veganIcon") {
            if health == true && vegan == false {
                firstAdvImageView.image = healthImage
            } else if health == true && vegan == true {
                firstAdvImageView.image = healthImage
                secondAdvImageView.image = veganImage
            } else if vegan == true && health == false {
                firstAdvImageView.image = veganImage
            } else {
                firstAdvImageView.image = nil
                secondAdvImageView.image = nil
            }
        }
        
    }
    
}
