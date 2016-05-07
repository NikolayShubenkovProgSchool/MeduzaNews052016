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
    }
}
