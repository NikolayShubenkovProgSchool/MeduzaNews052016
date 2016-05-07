//
//  CoreDataTableViewController.swift
//  MeduzaNews
//
//  Created by Nikolay Shubenkov on 17/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

class CoreDataTableViewController: UIViewController {
    
        @IBOutlet var tableView:UITableView!
        var cellIdentifier = "UITableViewCell"
        /* `NSFetchedResultsController`
        lazily initialized
        fetches the displayed domain model */
        var fetchedResultsController: NSFetchedResultsController {
            // return if already initialized
            if self._fetchedResultsController != nil {
                return self._fetchedResultsController!
            }
            
            let context = NSManagedObjectContext.MR_context()
            /* `NSFetchRequest` config
            fetch all `Item`s
            order them alphabetically by name
            at least one sort order _is_ required */
            let req = request()
            
            /* NSFetchedResultsController initialization
            a `nil` `sectionNameKeyPath` generates a single section */
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: nil)
            aFetchedResultsController.delegate = self
            self._fetchedResultsController = aFetchedResultsController
            
            // perform initial model fetch
            do {
                try self._fetchedResultsController!.performFetch()
                
            }
            catch {
                print("fetch error \(error)")
            }
            
            return self._fetchedResultsController!
        }
        var _fetchedResultsController: NSFetchedResultsController?
        
        //MARK: - Override this
        //override
        func request()->NSFetchRequest {
            let request = NSFetchRequest()//NewsItem.MR_requestAll()
            
            return request
        }
        /* helper method to configure a `UITableViewCell`
        ask `NSFetchedResultsController` for the model */
        func configureCell(cell: UITableViewCell,
            atIndexPath indexPath: NSIndexPath) {
                
        }
    func itemAt(index:NSIndexPath)->AnyObject {
        return fetchedResultsController.fetchedObjects![index.row]
    }
}

//MARK: - TableView Data Source
extension CoreDataTableViewController:UITableViewDataSource {
    // table view data source
    // ask the `NSFetchedResultsController` for the section
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            let info = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return info.numberOfObjects
    }
    
    // create and configure each `UITableViewCell`
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
            self.configureCell(cell, atIndexPath: indexPath)
            return cell
    }
}

//MARK: - FetchedResultsController Delegate
extension CoreDataTableViewController : NSFetchedResultsControllerDelegate {
    // fetched results controller delegate
    
    /* called first
    begins update to `UITableView`
    ensures all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath!)
                self.configureCell(cell!, atIndexPath: indexPath!)
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
    }
    
    /* called last
    tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
        }
}
