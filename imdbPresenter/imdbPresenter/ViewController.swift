//
//  ViewController.swift
//  imdbPresenter
//
//  Created by Komputer on 13/06/15.
//  Copyright (c) 2015 UAM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var area:UILabel?
    @IBOutlet weak var capital:UILabel?
    @IBOutlet weak var continent:UILabel?
    @IBOutlet weak var currency:UILabel?
    @IBOutlet weak var phone:UILabel?
    @IBOutlet weak var population:UILabel?
    @IBOutlet weak var tld:UILabel?
    
    @IBOutlet var headlineCollection: [UILabel] = []
    @IBOutlet var bodyCollection: [UILabel] = []
    
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
        self.continent?.text = "None"
        self.currency?.text = "None"
        self.phone?.text = "None"
        self.tld?.text = "None"
    }
    
}
