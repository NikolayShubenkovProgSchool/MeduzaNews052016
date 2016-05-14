//
//  ContentRetriever.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord

class ContentRetriever: NSObject {
    
    //static - озанчает, что это переменная или метод класса, а не его переменной
    static let shared = ContentRetriever()
    
    //news, cards, articles, shapito или polygon
    enum NewsType:String
    {
        case News  = "news"
        case Cards = "cards"
        case Articles = "articles"
        case Shapito  = "shapito"
        case Polygon  = "polygon"
    }
    
    func getNews(type:NewsType,page:Int,success:(Bool->Void)){
//https://meduza.io/api/v3/search?
        //chrono=news&page=0&per_page=30&locale=ru
        //параметры запроса
        let params = [
            "chrono" : type.rawValue,
            "page"   : page,
            "per_page" : Constants.NewsCountPerPage,
            "locale"   : Constants.Language
        ]
        Alamofire.request(.GET,
                          Constants.APILink.URLByAppendingPathComponent("search"),
                          parameters:params as? [String : AnyObject],
                          encoding: .URLEncodedInURL,
                          headers: nil).responseJSON { response in
            self.updateNewsFromResponse(response,success: success)
        }
    }
    
    func getNewsDetailesFor(newsID:String,success:(Bool->Void)){
        print("news detailes: \(Constants.APILink.URLByAppendingPathComponent(newsID))")
        Alamofire.request(.GET,
                          Constants.APILink.URLByAppendingPathComponent(newsID)).responseJSON { (response) in
                            if (response.result.error != nil){
                                success(false)
                                return
                            }
                            
                            let info = response.result.value as! NSDictionary
                            MagicalRecord.saveWithBlock({ context in
                                NewsItem.createNewsItemFromInfo(info["root"] as! NSDictionary, inContext: context)
                                
                                }, completion: { (_, error) in
                                    success(error == nil)
                            })
        }
    }
}

private extension ContentRetriever {
    struct Constants {
        static let NewsCountPerPage = 15
        static let Language = "ru"
        static let APILink  = NSURL(string:"https://meduza.io/api/v3/")!
    }
    
    func updateNewsFromResponse(response:Response<AnyObject, NSError>,success:(Bool->Void)){
        if (response.result.error != nil) {
            print("error for news \(response.result.error!)")
            success(false)
            return
        }
        guard let JSON = response.result.value  as? [String:AnyObject],
              let documents = JSON["documents"] as? [String:NSDictionary] else {
                success(false)
                return
        }
        
        MagicalRecord.saveWithBlock { context in
            // ключами являются ссылки, а значениями сами новости
            // нам нужны только значения, поэтому при переборе пар ключ\значение
            // для ключей стоит "_"
            for (_,info) in documents{
                NewsItem.createNewsItemFromInfo(info, inContext: context)
            }
        }
        success(true)
    }
}
















