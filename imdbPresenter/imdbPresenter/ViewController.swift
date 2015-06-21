//
//  ViewController.swift
//  imdbPresenter
//
//  Created by Komputer on 13/06/15.
//  Copyright (c) 2015 UAM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var area:UILabel?
    @IBOutlet weak var capital:UILabel?
    @IBOutlet weak var population:UILabel?
    
    @IBOutlet var headlineCollection: [UILabel] = []
    @IBOutlet var bodyCollection: [UILabel] = []
    
    @IBOutlet weak var titleBar: UINavigationItem!
    
    var data : String = ""
    
    func setData(newData : String) {
        if(data != newData) {
            self.data = newData
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        println(self.headlineCollection)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resourcs that can be recreated.
    }
    
    func configureView() {
        for label in self.headlineCollection {
            label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        }

        for label in self.bodyCollection {
            label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        
        self.title = self.data
        
        self.area?.text = "None"
        self.population?.text = "None"
        self.capital?.text = "None"
    }
    
    @IBAction func openLinkAction(sender: UIButton) {
        if let url = NSURL(string: "http://wp.pl") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
}
