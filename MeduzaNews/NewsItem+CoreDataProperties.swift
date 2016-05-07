//
//  NewsItem+CoreDataProperties.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NewsItem {

    @NSManaged var title: String?
    @NSManaged var date: NSTimeInterval
    @NSManaged var link: String?
    @NSManaged var text: String?
    @NSManaged var type: String?
    @NSManaged var images: NSSet?

}
