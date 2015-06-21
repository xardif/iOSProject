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
    @IBOutlet weak var imdbIdLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet var headlineCollection: [UILabel] = []
    @IBOutlet var bodyCollection: [UILabel] = []
    
    var data : Indexable?
    var url : String = "http://imdb.com/"

    func setData(newData : Indexable) {
        if(data?.getJsonDict() != newData.getJsonDict()) {
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
        
        if let actor = data as? Actor {
            self.title = "Actor"
            self.nameLabel?.text = actor.name
            self.imdbIdLabel?.text = actor.imdbId
            self.descLabel?.text = actor.desc
            self.url = "http://imdb.com/name/" + actor.imdbId + "/"
        } else if let movie = data as? Movie {
            self.title = "Movie"
            self.nameLabel?.text = movie.title
            self.imdbIdLabel?.text = movie.imdbId
            self.descLabel?.text = movie.titleDescription
            self.url = "http://imdb.com/title/" + movie.imdbId + "/"
        }
    }
    
    @IBAction func openLinkAction(sender: UIButton) {
        if let url = NSURL(string: self.url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}