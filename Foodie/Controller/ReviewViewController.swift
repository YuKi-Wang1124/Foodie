//
//  ReviewViewController.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/6/30.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantImage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)

        }
        
        
        
        // 應用模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        let moveUpTransform = CGAffineTransform(translationX: 0, y: -600)
        closeButton.transform = moveUpTransform
        
        // 使按鈕隱藏
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
         }
        
        
        
    }
        
        override func viewWillAppear(_ animated: Bool) {
            for index in 0...4 {
                UIView.animate(withDuration: 0.4, delay: (0.1 + 0.05 * Double(index)), usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
                    self.rateButtons[index].alpha = 1.0
                    self.rateButtons[index].transform = .identity
                }, completion: nil)
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
                self.closeButton.transform = .identity
            }, completion: nil)
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
