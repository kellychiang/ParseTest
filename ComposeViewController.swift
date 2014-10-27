//
//  ComposeViewController.swift
//  ParseTest
//
//  Created by kelly on 2014/10/15.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController ,UITextViewDelegate {

    @IBOutlet weak var sweetTextView: UITextView! = UITextView ()
    @IBOutlet weak var charRemainingLabel: UILabel! = UILabel ()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sweetTextView.layer.borderColor = UIColor.blackColor().CGColor
        sweetTextView.layer.borderWidth = 0.5
        sweetTextView.layer.cornerRadius = 5
        sweetTextView.delegate = self
        
        
        sweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSweenButton(sender: AnyObject) {
        
        var sweet: PFObject = PFObject(className: "sweets")
        sweet["content"] = sweetTextView.text
        sweet["sweeter"] = PFUser.currentUser()
        
        sweet.saveInBackground()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var newlegth:Int = ( textView.text as NSString).length + ( text as NSString).length - range.length
        var remainingChar:Int = 140 - newlegth
        
        charRemainingLabel.text = "\(remainingChar)"
        
        return (newlegth > 140) ? false : true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
