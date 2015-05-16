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
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    
    var backCard: Card? // ? => can have a value or can be nil
    var frontCard: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardStackView.backgroundColor = UIColor.clearColor()
        
        backCard = createCard(backCardTopMargin)
        cardStackView.addSubview(backCard!.swipeView)
        
        frontCard = createCard(frontCardTopMargin)
        cardStackView.addSubview(frontCard!.swipeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }

    private func createCard(topMargin: CGFloat) -> Card {
        let cardView = CardView()
        let swipeView = SwipeView(frame: createCardFrame(topMargin))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView)
    }
    
    // MARK : SwipeViewDelegate
    
    func swipeLeft() {
        println("LEFT")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }
    
    func swipeRight() {
        println("RIGHT")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }

}
