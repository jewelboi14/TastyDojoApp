//
//  PersistingManager.swift
//  TastyDojoApp
//
//  Created by Михаил on 08.10.2021.
//

import Foundation
import CoreData
import UIKit

class PersistingManager {
    
    //MARK: - Properties
    
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    
    //MARK: - Save to CoreData and load
    
    func saveRecipeInfo(title: String, summary: String, ingredients: [String], steps: [String] , completion: (Bool) -> Void) {
        
        let savedRecipe = RecipeCoreDataModel(context: context)
        if context.hasChanges {
            savedRecipe.savedSteps = steps
            savedRecipe.savedTitle = title
            savedRecipe.savedIngredients = ingredients
            savedRecipe.savedSummary = summary
            do {
                try self.context.save()
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
    func loadRecipeInfo(completion: @escaping ([RecipeCoreDataModel]) -> Void) {
        
        DispatchQueue.global().async {
            do {
                let request = RecipeCoreDataModel.fetchRequest() as NSFetchRequest<RecipeCoreDataModel>
                let sortDescriptor = NSSortDescriptor(key: "savedTitle", ascending: true,selector: #selector(NSString.localizedStandardCompare))
                request.sortDescriptors = [sortDescriptor]
                let characters = try self.context.fetch(request)
                DispatchQueue.main.async {
                    completion(characters)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    //MARK: - Save and retrieve image
    
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        createDirIfNeeded(dirName: fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    private func createDirIfNeeded(dirName: String) {
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dirName)
        if FileManager.default.fileExists(atPath: dir.path) == false {
            do {
                try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String, completion: (UIImage) -> Void) {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            guard let image = UIImage(contentsOfFile: imageUrl.path) else { return }
            
            completion(image)
            
        }
    }
    
}
