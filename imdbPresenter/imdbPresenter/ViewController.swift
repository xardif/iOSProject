//
//  ViewController.swift
//  imdbPresenter
//
//  Created by Komputer on 13/06/15.
//  Copyright (c) 2015 UAM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDataDelegate {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imdbIdLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonBar: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var headlineCollection: [UILabel] = []
    @IBOutlet var bodyCollection: [UILabel] = []
    
    var data : Indexable?
    
    // MARK: - Image display
    @IBOutlet weak var imageView: UIImageView!
    var photoView : UIImageView?
    var url : String = "http://imdb.com/"
    var downloadedData : NSMutableData?
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        downloadedData?.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if (error != nil) {
            println(error)
        } else {
            if let data = downloadedData {
                let image = UIImage(data: data)
                imageView.image = image
                imageView.layer.masksToBounds = true
                //center the picture
                imageView.contentMode = .ScaleAspectFill
                
                //create blur effect
                var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
                visualEffectView.frame = imageView.bounds
                visualEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                //add blur layer
                imageView.addSubview(visualEffectView)
                
                let photoView = UIImageView()
                photoView.frame.size = CGSize(width: 320, height: imageView.bounds.height)
                photoView.center = CGPointMake(imageView.bounds.width / 2, imageView.bounds.height / 2)
                
                photoView.image = image
                photoView.contentMode = .ScaleAspectFit
                photoView.clipsToBounds = true
                self.photoView = photoView
                
                imageView.addSubview(photoView)

                
                downloadedData = nil
            }
        }
    }
    

    func setData(newData : Indexable) {
        if(data?.getJsonDict() != newData.getJsonDict()) {
            self.data = newData
            self.configureView()
        }
    }
    
    // MARK: - View init with rotation fix
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(data != nil){
            self.configureView()
        }
        
        let thickness = CGFloat(0.3)
        //Top border
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor.lightGrayColor()
        topBorder.frame = CGRectMake(0, 0, buttonBar.frame.size.width, thickness)
        buttonBar.addSubview(topBorder)
        
        //Bottom border
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGrayColor()
        bottomBorder.frame = CGRectMake(0, buttonBar.frame.size.height - thickness, buttonBar.frame.size.width, thickness)
        buttonBar.addSubview(bottomBorder)
        
    }
    
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //Fix photoView on rotate
        photoView?.center.x = size.width / 2
    }
    
    func resolvePhotoViewPosition(collapseWidth : CGFloat){
        photoView?.center.x = (self.imageView.frame.width + collapseWidth) / 2
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resourcs that can be recreated.
    }
    
    // MARK: - Init labels with data
    
    func configureView() {
        if let url = NSURL(string: self.data!.getUrl()) {
            downloadedData = NSMutableData()
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration,
                delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            let task = session.dataTaskWithURL(url)
            task.resume()
        }
        
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