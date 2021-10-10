//
//  RecipeViewModel.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import UIKit

final class RecipeListViewModel {
    
    //MARK: - Properties
    
    private var numberOfPages = 20
    private var offsetOfPages = 10
    
    private let networkManager = NetworkManager()
    
    var isFiltering = false
    
    var recipes: [RecipeResults] = []
    var filteredRecipes: [RecipeResults] = []
    
    var query = ""
    
    //MARK: - Fetch methods
    
    func fetchRecipeInfo(query: String, completion: @escaping ([RecipeResults]) -> ()) {
        networkManager.getRecipeInfo(query: query) { recipes in
            self.recipes = recipes
            for index in 0...self.recipes.count-1 {
                self.recipes[index].summary = self.recipes[index].summary
                    .replacingOccurrences(of: "<b>", with: "")
                    .replacingOccurrences(of: "</b>", with: "")
                    .replacingOccurrences(of: "<a", with: "")
                    .replacingOccurrences(of: "href=", with: "")
                    .replacingOccurrences(of: "</a>", with: "")
                    .replacingOccurrences(of: ">", with: "")
            }
            completion(recipes)
        }
    }
    
    func fetchRecipeImage(url: String, completion: @escaping (UIImage) -> ()) {
        networkManager.getRecipeImage(withUrl: url) { image in
            completion(image)
        }
    }
    
    func fetchMoreRecipes(completion: @escaping ([RecipeResults]) -> ()) {
        networkManager.getRecipeInfo(query: query,
                                     number: String(numberOfPages),
                                     offset: String(offsetOfPages)) { recipes in
            self.recipes.append(contentsOf: recipes)
            for index in 0...self.recipes.count-1 {
                self.recipes[index].summary = self.recipes[index].summary
                    .replacingOccurrences(of: "<b>", with: "")
                    .replacingOccurrences(of: "</b>", with: "")
                    .replacingOccurrences(of: "<a", with: "")
                    .replacingOccurrences(of: "href=", with: "")
                    .replacingOccurrences(of: "</a>", with: "")
                    .replacingOccurrences(of: ">", with: "")
            }
            self.numberOfPages += 10
            self.offsetOfPages += 10
            completion(recipes)
        }
    }
    
}

