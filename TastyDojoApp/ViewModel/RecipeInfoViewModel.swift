//
//  RecipeInfoViewModel.swift
//  TastyDojoApp
//
//  Created by Михаил on 10.10.2021.
//

import UIKit

final class RecipeInfoViewModel {
    
    //MARK: - Properties
    
    var ingredients: [String] = []
    var steps: [String] = []
    private let persistingManager = PersistingManager()
    
    //MARK: - Methods
    
    func saveInfo(title: String,
                  summary: String,
                  ingredients: [String],
                  steps: [String],
                  completion: (Bool) -> Void) {
        persistingManager.saveRecipeInfo(title: title,
                                         summary: summary,
                                         ingredients: ingredients,
                                         steps: steps) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func saveImage(title: String, image: UIImage) {
        persistingManager.saveImage(imageName: title, image: image)
    }
    
}
