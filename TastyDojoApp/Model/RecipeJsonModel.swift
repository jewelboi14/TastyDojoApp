//
//  RecipeJsonModel.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import Foundation

struct RecipeJsonModel: Decodable {
    
    let results: [RecipeResults]
    
}

struct RecipeResults: Decodable {
    
    let title: String
    let image: String
    var summary: String
    let vegan: Bool
    let veryHealthy: Bool
    let analyzedInstructions: [Instructions]
    let extendedIngredients: [Ingredients]
    
}

struct Ingredients: Decodable {
    let original: String
}

struct Instructions: Decodable {
    let steps: [Steps]
    
}

struct Steps: Decodable {
    var step: String
    
}
