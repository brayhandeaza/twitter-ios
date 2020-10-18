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
        
        self.tableView.refreshControl = refresh
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets(moreTweet: false)
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
        let tweets = tweetsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        let user =  tweets["user"] as! NSDictionary
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
       
        
        if let imageData = data  {
            cell.profileImage.layer.borderWidth = 1.0
            cell.profileImage.layer.borderColor = UIColor.white.cgColor
            cell.profileImage.layer.masksToBounds = true
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height / 2
            cell.profileImage.clipsToBounds = true
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        cell.profileName.text = user["name"] as? String
        cell.tweetContent.text = tweetsArray[indexPath.row]["text"] as? String
        cell.tweetId = tweets["id"] as! Int
        
        cell.setFavorite((tweetsArray[indexPath.row]["favorited"] as? Bool)!)
        cell.favorited = (tweets["favorited"] as? Bool)!
        cell.setRetweeted((tweetsArray[indexPath.row]["retweeted"] as? Bool)!)
        cell.retweeted = (tweets["retweeted"] as? Bool)!

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
