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
    
    var restaurant = Restaurant()

    // MARK: - View controller life cycle 視圖控制器生命週期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        // 使導覽列不下移
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 設定頭視圖
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        
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
        self.navigationController?.navigationBar.barStyle = .black
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
  
    
    // MARK: - Table view data source 表格視圖資料源
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
            cell.descriptionLabel.text = restaurant.description
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}
