//
//  FeedTableViewController.swift
//  Saturn
//
//  Created by Zsolt Mester on 2017. 05. 16..
//  Copyright © 2017. Zsolt Mester. All rights reserved.
//

import CoreData
import UIKit

class FeedTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

	func initializeFetchedResultsController() {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsFeed")
		let sort = NSSortDescriptor(key: "name", ascending: true)
		request.sortDescriptors = [sort]

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let moc = appDelegate.model.context!
		fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("Failed to initialize FetchedResultsController: \(error)")
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		initializeFetchedResultsController()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		print("Number of sections: \(fetchedResultsController.sections!.count)")
        return fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchedResultsController.sections else {
			fatalError("No sections in fetchedResultsController")
		}
		let sectionInfo = sections[section]
		print("Rows in the \(section). section: \(sectionInfo.numberOfObjects)")
		return sectionInfo.numberOfObjects
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as! FeedTableViewCell
		// Set up the cell
		guard let object = self.fetchedResultsController?.object(at: indexPath) as? NewsFeed else {
			fatalError("Attempt to configure cell without a managed object")
		}

		cell.nameLabel.text = object.name
		print(cell.nameLabel.text!)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
