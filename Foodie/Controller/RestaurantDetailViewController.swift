//
//  RestaurantDetailViewController.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/6/2.
//


import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurant: RestaurantMO!

    // MARK: - View controller life cycle 視圖控制器生命週期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .lightGray
        
        // 使導覽列不下移
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 設定頭視圖
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        
        if let restaurantImage = restaurant.image {
            headerView.headerImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        // 第一次載入時顯示餐廳評價
        if let rating = restaurant.rating {
            headerView.ratingImageView.image = UIImage(named: rating)
        }
        
        
        
        // 建立表格視圖間的連結
        tableView.delegate = self
        tableView.dataSource = self
        
        // 移除表格分隔符號
        tableView.separatorStyle = .none
    }
    
    // 當一個視圖準備要顯示時，viewWillAppear 會被呼叫
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 把目前 navigationBar 改為深色模式
        self.navigationController?.navigationBar.barStyle = .default
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
  
    
    // MARK: - Table view data source 表格視圖資料源
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // 3 Row , 設定表格內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(systemName: "phone")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = restaurant.phone
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(systemName: "map")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = restaurant.location
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant.summary
            cell.selectionStyle = .none
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "HOW TO GET HERE"
            cell.selectionStyle = .none
            
            return cell
        
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            
            if let restaurantLocation = restaurant.location {
                cell.configure(location: restaurantLocation)
            }
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
            
        } else if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: {
            
            if let rating = segue.identifier {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
                
                // 將變更儲存在資料庫
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
                
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1.0
                }, completion: nil)
            }
        })
    }
}
