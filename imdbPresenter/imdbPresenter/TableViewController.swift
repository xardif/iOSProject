//
//  ViewController.swift
//  imdbPresenter
//
//  Created by Komputer on 13/06/15.
//  Copyright (c) 2015 UAM. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    enum ImdbSearchScope {
        case Movies
        case Actors
    }
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filteredList:[String] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.searchBar.scopeButtonTitles = ["Movies", "Actors"]
        self.searchController.searchBar.delegate = self
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.searchController.searchBar.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "UYLSegueShowCountry")
        {
            let indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as UITableViewCell)!
            var data : String
            if (self.searchController.active)
            {
                data = self.filteredList[indexPath.section]
            }
            else
            {
                data = self.data[indexPath.section] as String
            }
            
            let controller : ViewController = segue.destinationViewController.topViewController as ViewController
            controller.setData(data)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : Cell = self.tableView.dequeueReusableCellWithIdentifier("UYLCountryCellIdentifier",
            forIndexPath: indexPath) as Cell
        
        
        
        var data : String
        if (self.searchController.active)
        {
            data = self.filteredList[indexPath.section]
        }
        else
        {
            data = self.data[indexPath.section] as String
        }
        
        cell.countryLabel.text = data
        cell.capitalLabel.text = "Pusto"
    

        cell.countryLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.capitalLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active) {
            return self.filteredList.count
        } else {
            return 1
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.searchController.active) {
            return self.filteredList.count
        } else {
            return self.data.count
        }
    }
    
    func numberOfRowsInSection(tableView: UITableView, section: Int) -> Int {
        if (self.searchController.active) {
            return self.filteredList.count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(!self.searchController.active) {
            return Array(arrayLiteral: self.data[section])[0]
        }
        return nil
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if(!self.searchController.active) {
            return data.map({ (elem:String) -> String in
                println(Array(elem)[0])
                return String(Array(elem)[0])
            })
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if(!self.searchController.active) {
            println("lololo index : \(index)")
            if(index > 0) {
                //if Movie then 0 else Actor
                return index-1
            } else {
                let searchBarFrame : CGRect = self.searchController.searchBar.frame
                self.tableView.scrollRectToVisible(searchBarFrame, animated: false)
                return NSNotFound
            }
        }
        return 0
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(self.searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        self.searchForText(searchString)
        tableView.reloadData()
    }
    
    func searchForText(searchText: String) {
        self.filteredList = self.data.filter({ (elem: String) -> Bool in
            return elem.lowercaseString.contains(searchText.lowercaseString)
        })
    }
}

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
    
}
