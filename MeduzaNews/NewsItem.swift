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
        
        let item = findOrCreateNewsItemFromInfo(info, context: inContext)
        
        item.title = (info["title"] as! String)
        item.link  = (info["url"]   as! String)
        item.date  = NSTimeInterval(info["published_at"] as! Int)
        item.type  = (info["document_type"] as! String)
        if let content = info["content"] as? NSDictionary,
            let body   = content["body"] as? String {
            item.text  = body
        }
        
        if  let imagesInfo = info["image"] as? NSDictionary,
            let imageURL   = imagesInfo["large_url"] as? String {
            let image      = Image.findOrCreateImageWithURL(imageURL, context: inContext)
            
            //найдем элементы из картинок с такой же ссылкой
            let filteredImages = item.images?.filter({ $0.link == image })
            
            //если таких элементов нет, то добавим картинку к новости
            if filteredImages?.count == 0 {                
                item.images = item.images?.setByAddingObject(image)
            }
        }
        
        return item
    }
    

    
    class func findOrCreateNewsItemFromInfo(info:NSDictionary, context:NSManagedObjectContext)->NewsItem
    {
        let newsId = (info["url"] as! String)
        
        var newsItem = NewsItem.MR_findFirstByAttribute("link",
                                                        withValue: newsId,
                                                        inContext:context)
        if newsItem != nil {
            return newsItem!
        }
        
        newsItem = NewsItem.MR_createEntityInContext(context)
        
        newsItem?.link = newsId
        
        return newsItem!
    }
}
