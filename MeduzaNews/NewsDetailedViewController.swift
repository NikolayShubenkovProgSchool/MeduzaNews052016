//
//  NewsDetailedViewController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import Alamofire

class NewsDetailedViewController: UIViewController {

    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var newsIdValue:String! {
        didSet {
            newsItem = NewsItem.MR_findFirstByAttribute("link", withValue: newsIdValue)
        }
    }
    var newsItem:NewsItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var newsContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if newsItem.images?.count == 0{
            imageHeight.constant  = 0
        }
        else {
            var imageURL = "https://meduza.io"
            imageURL += (newsItem.images?.anyObject() as! Image).link!
            Alamofire.request(.GET, imageURL).responseData(completionHandler: { response in
                if let data = response.result.value {
                    self.imageView.image = UIImage(data: data)
                }
            })
        }
        let attributedString = try! NSAttributedString(data: newsItem.text!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        newsContent.attributedText = attributedString

    }
}
