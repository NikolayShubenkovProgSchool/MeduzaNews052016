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
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        //1. Зададим идентификатор ячейки
        cellIdentifier = "NewsCellID"
        super.viewDidLoad()
        setupCellsAutoSizing()
        updateData()
        tableView.delegate = self
        setupSearch()
    }
    
    //перед тем как появится на экране вызывается этот метод
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //обратимся к классу (радиостанции), который оповещает своих подписчиков о событиях
        //observer -  это слушатель уведомлений
        NSNotificationCenter.defaultCenter().addObserver(self,
         //метод, который будет вызван у нашего контроллера при появлении клавиатуры
                                                         selector: #selector(NewsViewController.keyboardWillAppear(_:)),
         //название уведомления
                                                         name: UIKeyboardWillShowNotification,
         //объект, который нас инстересует. Передадим  nil, 
         //т.к. нас интересуют все случаи, когда это событие произошло
                                                         object: nil)
        NSNotificationCenter.defaultCenter()
        .addObserver(self,
                     //метод, который будет вызван
                     selector:  #selector(NewsViewController.keyboardWillDisappear(_:)),
                     //название уведомления
                     name: UIKeyboardWillHideNotification,
                     //объект
            object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillShowNotification,
                                                            object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification,
                                                            object: nil)
        
        
    }
    
    func keyboardWillAppear(notification:NSNotification)
    {
        print(notification)
        if let info = notification.userInfo,
           let frameValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            //тут будет лежать фрейм клавиатуры в ее конечном положение
            let keyboardFrame = frameValue.CGRectValue()
            //получим значение отступов для tableView
            //если их увеличить, это позволит иначе пролистывать содержимое таблицы
            var contentInset  = tableView.contentInset
            contentInset.bottom = keyboardFrame.height
            contentInset.top    = 44
            tableView.contentInset = contentInset
        }
    }
    
    func keyboardWillDisappear(notification:NSNotification)
    {
        print(notification)
        var contentInset  = tableView.contentInset
        contentInset.bottom = 0
        contentInset.top    = 64
        tableView.contentInset = contentInset
    }
    
    func setupSearch()
    {
        searchController.searchResultsUpdater = self
        
        //если для показа результатов используется другой контроллер,
        //а не этот (NewsViewController), то это свойство лучше сделать true,
        //иначе как false.
        searchController.dimsBackgroundDuringPresentation = false
        
        //Если пользователь перейдет на другой экран, то поле для поиска
        //пропадет
        self.definesPresentationContext = true
        
        //у таблицы есть возможность задать шапку. 
        //в качестве шапки мы поставим Вью специального класса (UISearchBar)
        tableView.tableHeaderView = searchController.searchBar
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
    
    var searchText:String = "" {
        //если поисковая строка поменялась
        //удалим наш fetchedResultsController и перзашгрузим tableView
        //это приведет к тому, что наш предок пересоздаст fetchedResultsCOntroller
        //и перезапросит у нас информацию по искомым объектам
        didSet {
            if oldValue != searchText {
                _fetchedResultsController = nil
                tableView.reloadData()
            }
        }
    }
    
    //Этот метод описывает, какие конкретно нам нужны новости
    override func request() -> NSFetchRequest {
        //определим, для новостей чему должны быть равны их поля
        //ищем только новости, у которых type равен news

        
        let request = NewsItem.MR_requestAllWithPredicate(nil)
        
        if searchText.isEmpty == false {
            //http://nshipster.com/nspredicate/
            //создадим поиск по элементам, у которых в заголовке или тексте встречается искомая строка
            //%@ означает, что вместо него будет подставлено некоторое значение объекта
            //cd означает поиск без учета регистра символов
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@ OR text CONTAINS[cd] %@",
                                              argumentArray:[searchText,searchText])
            
            request.predicate = searchPredicate
        }
        //Зададим способ сортировки наших новостей
        //сортируем по дате, по убыванию. Т.е. у кого дата больше, тот идет первым
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
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

extension NewsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print(searchController.searchBar.text)
        searchText = searchController.searchBar.text ?? ""
    }
}



