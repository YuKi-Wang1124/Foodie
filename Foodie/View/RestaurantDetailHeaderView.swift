//
//  RestaurantDetailHeaderView.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/6/8.
//

import UIKit

class RestaurantDetailHeaderView: UIView {
 
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            // 多行
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            // 標籤圓角
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var heartImageView: UIImageView! {
        didSet {
            heartImageView.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
            heartImageView.tintColor = .lightGray
        }
    }

    @IBOutlet var ratingImageView: UIImageView!
    
}
