//
//  StepCell.swift
//  TastyDojoApp
//
//  Created by Михаил on 05.10.2021.
//

import Foundation
import UIKit
 
final class StepCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "stepIdentifier"
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.backgroundColor = .mainPiggie()
        label.textColor = .backgroundLight()
        return label
    }()
    
    private let stepView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stepTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        stepView.addSubview(stepTextLabel)
        contentView.addSubview(stepView)
        contentView.addSubview(stepLabel)
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalTo: stepView.heightAnchor, constant: 40),
            
            stepLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            stepLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            stepLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            stepLabel.heightAnchor.constraint(equalToConstant: 30),
            
            stepTextLabel.topAnchor.constraint(equalTo: stepView.topAnchor),
            stepTextLabel.rightAnchor.constraint(equalTo: stepView.rightAnchor, constant: -4),
            stepTextLabel.leftAnchor.constraint(equalTo: stepView.leftAnchor, constant: 4),
            
            stepView.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 5),
            stepView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stepView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stepView.heightAnchor.constraint(equalTo: stepTextLabel.heightAnchor, multiplier: 1.1),
            
        ])
    }
    
    func setupStep(step: Int, stepText: String) {
        
        stepLabel.text = "Step \(step)"
        stepTextLabel.text = stepText
        
    }
}
