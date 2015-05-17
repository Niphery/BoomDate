//
//  ProfileViewController.swift
//  BoomDate
//
//  Created by Robin Somlette on 16-05-2015.
//  Copyright (c) 2015 Robin Somlette. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "profile-header"))
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToCards:")
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = currentUser()?.name
        currentUser()?.getPhoto({ (image) -> () in
            self.imageView.layer.masksToBounds = true
            self.imageView.contentMode = .ScaleAspectFill
            self.imageView.image = image
                    })
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func goToCards(button: UIBarButtonItem) {
        pageController.goToNextVC()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
