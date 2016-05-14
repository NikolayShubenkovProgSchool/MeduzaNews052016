//
//  MasterViewController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 14/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import RESideMenu_onlyLeft

class MasterViewController: RESideMenu {
    
    //особый этап инициализации контроллера.
    //вызывается когда контроллер создается из Storyboard
    //до viewDidLoad
    override func awakeFromNib() {
        backgroundImage = UIImage(named: "masterBackground")
        contentViewStoryboardID  = Constants.contentControllerStoryboardID
        leftMenuViewStoryboardID = Constants.leftMenuControllerStoryboardID
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.menuItemPressed(_:)), name: LeftMenuController.menuItemPressedNotification, object: nil)
    }
    
    func menuItemPressed(notification:NSNotification){
        
        let newsTypeRaw = notification.object as! String
        let newsType    = ContentRetriever.NewsType(rawValue: newsTypeRaw)!
        print(newsType)
        showNewsOfType(newsType)
    }
    
    func showNewsOfType(newsType:ContentRetriever.NewsType)
    {
        //достанем навигейшн конторллер, внутри которого видно новости
        let currentNavigationController = contentViewController as! UINavigationController
        //из навигейшн контроллера достанем текущий контроллер новостей
        let currentNewsController = currentNavigationController.viewControllers[0] as! NewsViewController
        
        //если уже показаны новости выбранного типа, просто скроем меню
        if currentNewsController.newsType == newsType {
            hideMenuViewController()
            return
        }
        
        let otherNewsController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.contentControllerStoryboardID) as! UINavigationController
        
        //поменяем тип новостей у нового контроллера
        (otherNewsController.viewControllers[0] as! NewsViewController).newsType = newsType
        
        setContentViewController(otherNewsController, animated: true)
        hideMenuViewController()
    }
}

private extension MasterViewController
{
    struct Constants {
        static let contentControllerStoryboardID  = "NewsVCContainer"
        static let leftMenuControllerStoryboardID = "LeftMenuController"
    }
}
