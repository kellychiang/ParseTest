//
//  TimeLineTableViewController.swift
//  ParseTest
//
//  Created by kelly on 2014/10/15.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController {
    
    var timelineData:NSMutableArray = NSMutableArray ()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     @IBAction func loadData () {
        timelineData .removeAllObjects()
        
        var findTimelineData : PFQuery = PFQuery(className: "sweets")
        
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil) {
                for object:AnyObject in objects {
                    self.timelineData.addObject(object as PFObject)
                }
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func  viewDidAppear(animated: Bool) {
        self.loadData()
        
        if (PFUser.currentUser() == nil) {
            var loginAlert : UIAlertController = UIAlertController (title: "sign up/login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your password"
                textfield.secureTextEntry = true
                
            })
            
            loginAlert.addAction(UIAlertAction (title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textfields :NSArray = loginAlert.textFields! as NSArray
                let usernametextfield :UITextField = textfields.objectAtIndex(0) as UITextField
                let passwordtextfield :UITextField = textfields.objectAtIndex(1) as UITextField
                
                PFUser.logInWithUsernameInBackground(usernametextfield.text, password: passwordtextfield.text) {
                    (user:PFUser! ,error:NSError!) -> Void in
                    if(user != nil) {
                        println("Login succesfull")
                    } else {
                        println("Login failed")
                    }
                }
                
            }))
            
            loginAlert.addAction(UIAlertAction (title: "Sign up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textfields :NSArray = loginAlert.textFields! as NSArray
                let usernametextfield :UITextField = textfields.objectAtIndex(0) as UITextField
                let passwordtextfield :UITextField = textfields.objectAtIndex(1) as UITextField
                
                var sweeter:PFUser = PFUser()
                sweeter.username = usernametextfield.text
                sweeter.password = passwordtextfield.text
                
                sweeter.signUpInBackgroundWithBlock({
                    (successs:Bool!, error:NSError!) -> Void in
                    if (error == nil) {
                        println("Sign up successful")
                    } else {
                        let errorString = error.userInfo!["error"] as NSString
                            println(errorString)
                        
                    }
                })
            }))
            self.presentViewController(loginAlert, animated: true, completion:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return timelineData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SweetTableViewCell
        
        let sweet:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
        
        cell.sweetTextView.alpha = 0
        cell.timestampLabel.alpha = 0
        cell.usernameLabel.alpha = 0
        
        cell.sweetTextView.text = sweet.objectForKey("content") as String
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timestampLabel.text = dateFormatter.stringFromDate(sweet.createdAt)
        
        var findSweeter:PFQuery = PFUser.query()
        findSweeter.whereKey("objectId", equalTo: sweet.objectForKey("sweeter").objectId)
        
        findSweeter.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil) {
                let user:PFUser = (objects as NSArray).lastObject as PFUser
                cell.usernameLabel.text = user.username
                
                UIView.animateWithDuration(0.5, animations: {
                    cell.sweetTextView.alpha = 1
                    cell.timestampLabel.alpha = 1
                    cell.usernameLabel.alpha = 1
                })
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
