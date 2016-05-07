//
//  NewsItem.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import Foundation
import CoreData


class NewsItem: NSManagedObject {

    class func createNewsItemFromInfo(info:NSDictionary,inContext:NSManagedObjectContext)->NewsItem {
        
        let item = NewsItem.MR_createEntityInContext(inContext)!
        
        item.title = (info["title"] as! String)
        item.link  = (info["url"]   as! String)
        
        return item
    }
}
