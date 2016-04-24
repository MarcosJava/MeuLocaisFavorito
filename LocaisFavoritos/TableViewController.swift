//
//  TableViewController.swift
//  LocaisFavoritos
//
//  Created by Marcos Felipe Souza on 26/12/15.
//  Copyright © 2015 Marcos. All rights reserved.
//


/**

Desafio : 

-- Colocar armazenamento permanente.
-- Colocar o swip para deletar.

*/



import UIKit

var places = [Dictionary<String,String>()]
var activePlace = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("myLocation") != nil {
            places = NSUserDefaults.standardUserDefaults().objectForKey("myLocation") as! [Dictionary<String, String>]
        }
        
        if places.count == 1 {
            
            places.removeAtIndex(0)
            places.append(["name":"Taj Mahal", "lat":"27.175282", "lon":"78.042209"])
        }
        
        NSUserDefaults.standardUserDefaults().setObject(places, forKey: "myLocation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newPlace" {
            activePlace = -1
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = places[indexPath.row]["name"]

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row
        return indexPath
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {

            // 
            //  Confirm Alert Dialog
            //
            
//            let alertController = UIAlertController(title: "Atenção", message: "Deseja Deletar ?", preferredStyle: .Alert)
//            
//            let defaultAction = UIAlertAction(title: "Sim", style: .Default, handler: { (action) -> Void in
//                places.removeAtIndex(indexPath.row)
//                NSUserDefaults.standardUserDefaults().setObject(places, forKey: "myLocation")
//                tableView.reloadData()
//
//            })
//            
//            let cancelAction = UIAlertAction(title: "Cancelar", style: .Default, handler: { (action) -> Void in
//                print("cancel")
//                
//            })
//            
//            alertController.addAction(defaultAction)
//            alertController.addAction(cancelAction)
//            
//            presentViewController(alertController, animated: true, completion: nil)
            
            
            // Alert Controller Sheet
            confirmDelete(places[indexPath.row]["name"]!, index: indexPath.row)
        }
    }
    
    func confirmDelete(place: String, index:Int) {
        
        let alert = UIAlertController(title: "Deletar Lugar", message: "Você tem certeza que deseja deletar \(place) ?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            places.removeAtIndex(index)
            NSUserDefaults.standardUserDefaults().setObject(places, forKey: "myLocation")
            self.tableView.reloadData()
            
        })
        
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("cancel")
            
        })
        
        
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
