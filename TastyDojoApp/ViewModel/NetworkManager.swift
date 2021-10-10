//
//  NetworkManager.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import UIKit

final class NetworkManager {
    
    //MARK: - Constants
    
    private let recipeUrl = "https://api.spoonacular.com/recipes/complexSearch?apiKey=ec731202fb0e4b5da5b9ab680d0b04ab&fillIngredients=true&addRecipeInformation=true&?&query="
    
    func getRecipeInfo(query: String, number: String = "10",
                       offset: String = "0",
                       completion: @escaping ([RecipeResults]) -> ()) {
        
        let actualUrl = recipeUrl + query + "&offset=\(offset)" + "&number=\(number)"
        guard let url = URL(string: actualUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let recipes = try JSONDecoder().decode(RecipeJsonModel.self, from: data)
                DispatchQueue.main.async {
                    completion(recipes.results)
                }
            } catch {
                print("can not fetch recipes \(error)")
            }
        }.resume()
        
    }
    
    func getRecipeImage(withUrl imageUrl: String, completion: @escaping (UIImage) -> ()) {
        
        guard let url = URL(string: imageUrl) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }.resume()
        
    }
    
}
