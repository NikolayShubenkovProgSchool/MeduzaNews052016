//
//  NewsDetailedViewController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class NewsDetailedViewController: UIViewController {

    var newsIdValue:String! {
        didSet {
            newsItem = NewsItem.MR_findFirstByAttribute("link", withValue: newsIdValue)
        }
    }
    var newsItem:NewsItem!
    
    @IBOutlet weak var newsContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = try! NSAttributedString(data: newsItem.text!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        newsContent.attributedText = attributedString

    }
}
