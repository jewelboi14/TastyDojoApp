//
//  RecipeCoreDataModel+CoreDataProperties.swift
//  TastyDojoApp
//
//  Created by Михаил on 10.10.2021.
//
//

import Foundation
import CoreData


extension RecipeCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCoreDataModel> {
        return NSFetchRequest<RecipeCoreDataModel>(entityName: "RecipeCoreDataModel")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var savedIngredients: [String]?
    @NSManaged public var savedSteps: [String]?
    @NSManaged public var savedSummary: String?
    @NSManaged public var savedTitle: String?

}

extension RecipeCoreDataModel : Identifiable {

}
