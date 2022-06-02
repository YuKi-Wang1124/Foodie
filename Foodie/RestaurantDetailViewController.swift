//
//  RestaurantDetailViewController.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/6/2.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet var restaurantImageView: UIImageView!
 
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    
    var restaurantImageName = ""
    var restaurantName = ""
    var restaurantLocation = ""
    var restaurantType = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        restaurantNameLabel.text = restaurantName
        restaurantLocationLabel.text = restaurantLocation
        restaurantTypeLabel.text = restaurantType
        
//        navigationItem.largeTitleDisplayMode = .never
        restaurantImageView.image = UIImage(named: restaurantImageName)
    }
    
    

}
