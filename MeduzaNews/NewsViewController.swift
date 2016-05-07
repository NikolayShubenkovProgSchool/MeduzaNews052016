//
//  NewsViewController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MagicalRecord

class NewsViewController: CoreDataTableViewController {

    lazy var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        //http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
        //http://goo.gl/stRF49
        formatter.dateFormat = "HH:mm, dd MMM"
        //язык
        formatter.locale = NSLocale(localeIdentifier: "RU-ru")
        return formatter
    }()
    
    override func viewDidLoad() {
        //1. Зададим идентификатор ячейки
        cellIdentifier = "NewsCellID"
        super.viewDidLoad()
        ContentRetriever.shared.getNews(.News, page: 0)
        setupCellsAutoSizing()
    }
    
    func setupCellsAutoSizing(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    //Этот метод описывает, какие конкретно нам нужны новости
    override func request() -> NSFetchRequest {
        //определим, для новостей чему должны быть равны их поля
        //ищем только новости, у которых type равен news
        let predicate = NSPredicate(format: "type == news")
        
        let request = NewsItem.MR_requestAllWithPredicate(nil)
        
        //Зададим способ сортировки наших новостей
        //сортируем по дате, по убыванию. Т.е. у кого дата больше, тот идет первым
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let newsCell = cell as! NewsItemTableViewCell
        let newsItem = itemAt(indexPath) as! NewsItem
        
        newsCell.newsTitleLabel.text = newsItem.title
        
        //setup date
        let date = NSDate(timeIntervalSince1970: newsItem.date)
        newsCell.dateLabel.text = dateFormatter.stringFromDate(date)
        
        newsCell.tagLabel.text = newsItem.type
    }
}
