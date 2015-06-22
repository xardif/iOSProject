//
//  ViewController.swift
//  imdbPresenter
//
//  Created by Komputer on 13/06/15.
//  Copyright (c) 2015 UAM. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, NSURLSessionDataDelegate  {
    
    var searchActive : Bool = false
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    
    let restMovieUrl = "http://rest-xardif.rhcloud.com/api/mongo/movies"
    let restActorUrl = "http://rest-xardif.rhcloud.com/api/mongo/actors"
    var state : DownloadState = .DownloadActor
    
    var movieDownloadedData, actorDownloadedData : NSMutableData?
    var data : [Indexable] = []
    var filteredList : [Indexable] = []
    var dataByLetterDict : [String:[Indexable]] = [:]
    var sortedKeys : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        initSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segue preparation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SegueShowData")
        {
            let indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as UITableViewCell)!
            var data : Indexable
            if (self.searchController.active)
            {
                data = self.filteredList[indexPath.row] //or section
            } else {
                let key = self.sortedKeys[indexPath.section]
                data = self.dataByLetterDict[key]![indexPath.row]
            }
            
            let controller : ViewController = segue.destinationViewController.topViewController as ViewController
            controller.setData(data)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - UITableView
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : Cell = self.tableView.dequeueReusableCellWithIdentifier("CellIdentifier",
            forIndexPath: indexPath) as Cell
        
        
        var data : Indexable
        if (self.searchController.active) {
            data = self.filteredList[indexPath.row]
        } else {
            let key = self.sortedKeys[indexPath.section]
            data = self.dataByLetterDict[key]![indexPath.row]
        }
        
        cell.nameLabel.text = data.getHeadline()
        cell.descLabel.text = data.getSmallHeadline()
        cell.typeLabel.text = (data is Actor) ? "A" : "M"
    

        cell.nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.descLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.typeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active) {
            return self.filteredList.count
        } else {
            let key = self.sortedKeys[section]
            return self.dataByLetterDict[key]!.count
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.searchController.active) {
            return 1
        } else {
            return self.sortedKeys.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(!self.searchController.active) {
            return self.sortedKeys[section]
        }
        return nil
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if(!self.searchController.active) {
            return self.sortedKeys
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if(!self.searchController.active) {
            if(index > 0) {
                return index
            } else {
                let searchBarFrame : CGRect = self.searchController.searchBar.frame
                self.tableView.scrollRectToVisible(searchBarFrame, animated: false)
                return NSNotFound
            }
        }
        return 0
    }
    
    // MARK: - SearchBar functions
    
    enum SearchScope: Int {
        case Movies = 0
        case Actors = 1
    }
    
    func initSearchController(){
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.searchBar.scopeButtonTitles = ["Movies", "Actors"]
        self.searchController.searchBar.delegate = self
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.searchController.searchBar.sizeToFit()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(self.searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let searchScope = SearchScope(rawValue: searchController.searchBar.selectedScopeButtonIndex)!
        self.searchForText(searchString, scope: searchScope)
        tableView.reloadData()
    }
    
    func searchForText(searchText: String, scope: SearchScope) {
        self.filteredList = self.data.filter({ (elem: Indexable) -> Bool in
            if(scope == .Actors) {
                return elem is Actor
                    && elem.getHeadline().lowercaseString.contains(searchText.lowercaseString)
            } else {
                return elem is Movie
                    && elem.getHeadline().lowercaseString.contains(searchText.lowercaseString)
            }
            })
            .sorted({$0.getHeadline() < $1.getHeadline()})
    }
    
    // MARK: - Downloading and parsing data
    
    enum DownloadState {
        case DownloadActor
        case DownloadMovie
    }
    
    func loadData(){
        if(state == .DownloadActor) {
            self.actorDownloadedData = NSMutableData()
        } else {
            self.movieDownloadedData = NSMutableData()
        }
        let urlString = (state == .DownloadActor) ? restActorUrl : restMovieUrl
        let url = NSURL(string: urlString)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let dataTask = session.dataTaskWithURL(url!)
        
        dataTask.resume()
    }

    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if(self.state == .DownloadActor) {
            actorDownloadedData?.appendData(data)
        } else if(self.state == .DownloadMovie)  {
            movieDownloadedData?.appendData(data)
        }
    }
    
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if (error != nil) {
            let alertController = UIAlertController(title: "Error", message:
                "No internet connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            if state == .DownloadMovie {
                parseData()
                self.actorDownloadedData = nil
                self.movieDownloadedData = nil
                self.tableView.reloadData()
            }
            
            if state == .DownloadActor {
                state = .DownloadMovie
                loadData()
            }
        }
    }
    
    func parseData() {
        if let data = actorDownloadedData {
            var error : NSError?
            let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error)
            if let result = jsonObject as? NSArray {
                for elem in result {
                    let actor = Actor(JSONDictionary: elem as NSDictionary)
                    self.data.append(actor)
                }
            }
        }
        if let data = movieDownloadedData {
            var error : NSError?
            let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error)
            if let result = jsonObject as? NSArray {
                for elem in result {
                    let movie = Movie(JSONDictionary: elem as NSDictionary)
                    self.data.append(movie)
                }
            }
        }
        for elem in self.data {
            var key = elem.getHeadline()[0].uppercaseString
            if let arrayForLetter = self.dataByLetterDict[key] {
                var array : [Indexable] = arrayForLetter
                array.append(elem)
                dataByLetterDict.updateValue(array, forKey: key)
            } else {
                dataByLetterDict.updateValue([elem], forKey: key)
            }
        }
        for (key, value) in self.dataByLetterDict {
            let sortedArray = value.sorted({$0.getHeadline() < $1.getHeadline()})
            self.dataByLetterDict.updateValue(sortedArray, forKey: key)
        }
        self.sortedKeys = self.dataByLetterDict.keys.array.sorted({$0 < $1})
    }
    
}

// MARK: - String extensions

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }

    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }

}
