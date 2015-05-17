//
//  CardsViewController.swift
//  BoomDate
//
//  Created by Robin Somlette on 13-05-2015.
//  Copyright (c) 2015 Robin Somlette. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {

    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
        let user: User
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    
    var backCard: Card? // ? => can have a value or can be nil
    var frontCard: Card?
    
    var users: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardStackView.backgroundColor = UIColor.clearColor()
        
//        backCard = createCard(backCardTopMargin)
//        cardStackView.addSubview(backCard!.swipeView)
//        
//        frontCard = createCard(frontCardTopMargin)
//        cardStackView.addSubview(frontCard!.swipeView)
        
        fetchUnViewedUsers { (users) -> () in
            self.users = users
//            println(self.users)
            if let card = self.popCard() {
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            }
            
            if let card = self.popCard() {
                self.backCard = card
                self.backCard?.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToProfile:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }

    private func createCard(user: User) -> Card {
        let cardView = CardView()
        cardView.name = user.name
        user.getPhoto { (image) -> () in
            cardView.image = image
        }
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    func goToProfile(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    private func switchCards() {
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            
        }
    }
    
    // MARK : SwipeViewDelegate
    
    func swipeLeft() {
        println("LEFT")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            switchCards()
        }
    }
    
    func swipeRight() {
        println("RIGHT")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            switchCards()
        }
    }

}
