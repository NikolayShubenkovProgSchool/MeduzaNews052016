//
//  LeftMenuController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 14/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class LeftMenuController: UITableViewController {
    static let menuItemPressedNotification = "LeftMenuItemPressedNotification"
    struct MenuItem {
        let name:String
        let newsType:ContentRetriever.NewsType
    }
    
    var menuItems:[MenuItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuItems()
        tableView.layoutIfNeeded()
        tableView.backgroundView  = nil
        tableView.backgroundColor = UIColor.clearColor()
        //центрирование по вертикали
        let height = (tableView.frame.height - tableView.contentSize.height) / 2
        
        //сдвигает контент куда угодно.
        tableView.contentInset  = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        //меняют размер контента отступами
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        //заблокирует скролл по вертикали, для случаев, когда контент по размеру меньше tableView
        tableView.alwaysBounceVertical = false
    }
    
    func setupMenuItems()
    {
        let news = MenuItem(name: "Новости", newsType: ContentRetriever.NewsType.News)
        let cards = MenuItem(name: "Картотека", newsType: ContentRetriever.NewsType.Cards)
        let articles = MenuItem(name: "Статьи", newsType: ContentRetriever.NewsType.Articles)
        let shapito = MenuItem(name: "Шапито", newsType: ContentRetriever.NewsType.Shapito)
        let polygon = MenuItem(name: "Полигон" , newsType: ContentRetriever.NewsType.Polygon)
        
        menuItems = [news,cards,articles,shapito,polygon]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuID", forIndexPath: indexPath)
        let menu = menuItems[indexPath.row]
        cell.textLabel?.text = menu.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuItem = menuItems[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    NSNotificationCenter.defaultCenter().postNotificationName(LeftMenuController.menuItemPressedNotification, object: menuItem.newsType.rawValue)
    }

}
