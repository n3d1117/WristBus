//
//  Common.swift
//  ataf
//
//  Created by ned on 06/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import UIKit

let tableViewBackgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
let purple = UIColor(red: 83/255.0, green: 74/255.0, blue: 172/255.0, alpha: 1)

protocol canAddBusStop { func addStop(stop: BusStop) }

// Delay function
func delay(_ delay : Double, closure: @escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UIRefreshControl {
    func beginRefreshingManually(animated: Bool) {
        delay(0.0) {
            if let scrollView = self.superview as? UIScrollView {
                self.beginRefreshing()
                let point = CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height)
                scrollView.setContentOffset(point, animated: animated)
                self.sendActions(for: UIControlEvents.valueChanged)
            }
        }
    }
}

extension UINavigationItem {
    func setTitle(title: String, subtitle: String) {
        
        //Create a label programmatically and give it its properties
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -4, width: 0, height: 0))
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        
        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        self.titleView = titleView
    }
}
