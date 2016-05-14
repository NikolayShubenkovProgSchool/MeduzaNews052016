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
        hideMenuViewController()
        print(newsType)
    }
}

private extension MasterViewController
{
    struct Constants {
        static let contentControllerStoryboardID  = "NewsVCContainer"
        static let leftMenuControllerStoryboardID = "LeftMenuController"
    }
}
