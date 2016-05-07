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

    var currentPage = 0
    
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
        setupCellsAutoSizing()
        updateData()
        tableView.delegate = self
    }
    
    func updateData()
    {
        ContentRetriever.shared.getNews(.News, page: currentPage, success: {
            updatedWithSuccess in
            if updatedWithSuccess {
                self.currentPage += 1
            }
        })
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
        
        let cellCountBeforeEnd = 5
        let totalCellsCount    = fetchedResultsController.fetchedObjects?.count
        
        //если это 5 с конца ячейка загрузим новые
        if totalCellsCount! - indexPath.row == cellCountBeforeEnd {
            updateData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? NewsDetailedViewController {
            destinationVC.newsIdValue = sender as! String
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsItem = itemAt(indexPath) as! NewsItem
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard newsItem.text?.isEmpty == false else {
            ContentRetriever.shared.getNewsDetailesFor(newsItem.link!, success: { wasUpdated in
                
                if wasUpdated {
                    self.showNewsItemDetailes(newsItem.link!)
                }
            })
            return
        }
        showNewsItemDetailes(newsItem.link!)
    }
    
    func showNewsItemDetailes(newsItemID:String){
        performSegueWithIdentifier("Show News Detailes", sender: newsItemID)
    }
}
