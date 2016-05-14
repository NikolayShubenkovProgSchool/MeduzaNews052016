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
    }
}

private extension MasterViewController
{
    struct Constants {
        static let contentControllerStoryboardID  = "NewsVCContainer"
        static let leftMenuControllerStoryboardID = "LeftMenuController"
    }
}
