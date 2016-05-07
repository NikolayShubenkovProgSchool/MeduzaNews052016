//
//  ContentRetriever.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import Alamofire

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
    
    func getNews(type:NewsType ,page:Int){
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
                          Constants.APILink,
                          parameters:params as? [String : AnyObject],
                          encoding: .URLEncodedInURL,
                          headers: nil).responseJSON { response in
                            print(response)
        }
        
    }
}

private extension ContentRetriever {
    struct Constants {
        static let NewsCountPerPage = 15
        static let Language = "ru"
        static let APILink  = NSURL(string:"https://meduza.io/api/v3/search")!
    }
}





