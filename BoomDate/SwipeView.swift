//
//  SwipeView.swift
//  BoomDate
//
//  Created by Robin Somlette on 12-05-2015.
//  Copyright (c) 2015 Robin Somlette. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    enum Direction {
        case None
        case Left
        case Right
    }
    
    weak var delegate: SwipeViewDelegate?
    
//    private let card: CardView = CardView()
    var innerView: UIView? {
        didSet {
            if let v = innerView {
                addSubview(v)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private var originalPoint: CGPoint?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    init() {
        super.init(frame: CGRectZero)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clearColor()
//        addSubview(card)
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
//        card.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        
//        card.setTranslatesAutoresizingMaskIntoConstraints(false)
//        setConstraints()
        
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
        println("Distance x:\(distance.x) y:\(distance.y)")
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
                originalPoint = center
        case UIGestureRecognizerState.Changed:
            let rotationPercentage = min(distance.x/(self.superview!.frame.width/2), 1)
            let rotationAngle = (CGFloat(2*M_PI/16) * rotationPercentage)
            transform = CGAffineTransformMakeRotation(rotationAngle)
            
            
            
                center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
        case UIGestureRecognizerState.Ended:
            
            if abs(distance.x) < frame.width/4 {
                resetViewPositionAndTransformation()
            } else {
                swipe(distance.x > 0 ? .Right : .Left)
            }
            
            
        default:
            println("Default trigged for GestureRecognizer")
            break
        }
        
    }
    
    func swipe(s: Direction) {
        if s == .None {
            return
        }
        
        var parentWidth = superview!.frame.size.width
        if s == .Left {
            parentWidth *= -1
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.center.x = self.frame.origin.x + parentWidth
            }, completion: {
                success in
                if let d = self.delegate {
                    s == .Right ? d.swipeRight() : d.swipeLeft()
                }
        })
        
//        if s == .Right {
//            
//        }
    }
    
    private func resetViewPositionAndTransformation() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0)
        })
    
    }
    
    
    
    
//    private func setConstraints() {
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
//    }
}

protocol SwipeViewDelegate: class {
    func swipeLeft()
    func swipeRight()
}