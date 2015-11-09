//
//  WatchlistModel.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 08/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class WatchlistModel: NSObject, UITableViewDataSource {
    
    private var traktModel: TraktModel
    private var watchlistArray: JSONDictionary
    
    init(traktModel: TraktModel) {
        self.traktModel = traktModel
        self.watchlistArray = []
        super.init()
    }
    
    func loadData(completionHandler: (success: Bool) -> Void) {
        let endPoint = TraktEndPoint.users.watchlist + "shows"
        self.traktModel.get(endPoint, parameters: nil) { (success, response) -> Void in
            if success {
                self.watchlistArray = response.JSONObject!
            }
            
            completionHandler(success: success)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchlistArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("standardCell", forIndexPath: indexPath)
        let item = self.watchlistArray[indexPath.row]

        if let label = cell.viewWithTag(101) as? UILabel {
            label.text = item["show"]!["title"] as? String
        }
        
//        if let image = cell.viewWithTag(102) as? UIImageView {
//            let url = NSURL(string: item["image"] as! String)
//            let data = NSData(contentsOfURL: url!)
//            image.image = UIImage(data: data!)
//        }
        
        return cell
    }
    
}
