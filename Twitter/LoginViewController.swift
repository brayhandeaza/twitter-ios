//
//  LoginViewController.swift
//  Twitter
//
//  Created by Brayhan De Aza on 10/6/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isLogedIn") {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    @IBAction func onLoginButton(_ sender: Any) {
        let myUr = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUr, success: {
            UserDefaults.standard.set(true, forKey: "isLogedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (error) in
            print("Could not log in, Error: \(error)")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
