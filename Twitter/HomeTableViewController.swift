//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Brayhan De Aza on 10/6/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let tweetsAPIUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    var tweetsArray = [NSDictionary]()
    var numberOfTweet: Int!
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets(moreTweet: false)
        refresh.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc func loadTweets(moreTweet: Bool) {
        if !moreTweet {
            numberOfTweet = 20
            
        } else {
            numberOfTweet = numberOfTweet + 20
            
        }
        
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsAPIUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetsArray.removeAll()
            for tweet in tweets {
                self.tweetsArray.append(tweet)
                
            }
            self.tableView.reloadData()
            
            if !moreTweet {
                self.refreshControl?.endRefreshing()
            }
            
        }, failure: {(error) in
            print("Could not get any tweet, Error: \(error)")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetsArray.count {
            loadTweets(moreTweet: true)
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "isLogedIn")
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        let user =  tweetsArray[indexPath.row]["user"] as! NSDictionary
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data  {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        cell.profileName.text = user["name"] as? String
        cell.tweetContent.text = tweetsArray[indexPath.row]["text"] as? String
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
        
    }
}
