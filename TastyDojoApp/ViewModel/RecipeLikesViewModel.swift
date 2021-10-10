//
//  RecipeLikesViewModel.swift
//  TastyDojoApp
//
//  Created by Михаил on 10.10.2021.
//

import UIKit

final class RecipeLikesViewModel {
    //MARK: - Properties
    
    var recipes: [RecipeCoreDataModel] = []
    private let persistingManager = PersistingManager()
    
    //MARK: - Fetch methods
    
    func loadRecipeFromData(completion: @escaping ([RecipeCoreDataModel]) ->()) {
        persistingManager.loadRecipeInfo { savedRecipes in
            self.recipes = savedRecipes
            completion(savedRecipes)
        }
    }
    
    func loadImageFromData(name: String, completion: @escaping (UIImage) -> ()) {
        persistingManager.loadImageFromDiskWith(fileName: name) { image in
            completion(image)
        }
        
    }
}
