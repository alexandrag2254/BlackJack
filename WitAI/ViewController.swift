//
//  ViewController.swift
//  WitAI
//
//  Created by Julian Abentheuer on 10.01.15.
//  Copyright (c) 2015 Aaron Abentheuer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WitDelegate {
    
    var labelView : UILabel?
    var witButton : WITMicButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set the WitDelegate object
        Wit.sharedInstance().delegate = self
        
        // create the button
        var screen : CGRect = UIScreen.mainScreen().bounds
        var w : CGFloat = 100
        var rect : CGRect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100)
        
        witButton = WITMicButton(frame: rect)
        self.view.addSubview(witButton!)
        
        // create the label
        labelView = UILabel(frame: CGRectMake(0, 200, screen.size.width, 50))
        labelView!.textAlignment = .Center
        labelView!.text = "intent"
        labelView!.textColor = UIColor.blackColor()
        labelView!.sizeToFit()
        self.view.addSubview(labelView!)
    }
    
    func witDidGraspIntent(outcomes: [AnyObject]!, messageId: String!, customData: AnyObject!, error e: NSError!) {
        if ((e) != nil) {
            println("\(e.localizedDescription)")
            return
        }
        
        var outcomes : NSArray = outcomes!
        var firstOutcome : NSDictionary = outcomes.objectAtIndex(0) as NSDictionary
        var intent : String = firstOutcome.objectForKey("intent") as String
        labelView!.text = intent
        labelView!.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

