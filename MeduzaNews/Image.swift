//
//  Image.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 07/05/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import Foundation
import CoreData


class Image: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func findOrCreateImageWithURL(url:String, context:NSManagedObjectContext)->Image {
        var imageToSearch:Image? = Image.MR_findByAttribute("link",
                                                            withValue: url,
                                                            inContext: context) as? Image
        if imageToSearch == nil {
            imageToSearch = Image.MR_createEntityInContext(context)
            imageToSearch?.link = url
        }
        
        return imageToSearch!
    }
    
}
