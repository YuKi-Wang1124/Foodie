//
//  RestaurantTableViewController.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/5/31.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet var  emptyRestaurantView: UIView!
    
    var  restaurants: [RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController: UISearchController!
    var searchResults: [RestaurantMO] = []
    
    // MARK: - 視圖控制器生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加上搜尋列
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 設定搜尋列樣式
        searchController.searchBar.placeholder = "Search restaurant..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        
        // 準備空視圖
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
        // 使用 ipad 橫向模式時好閱讀
        tableView.cellLayoutMarginsFollowReadableWidth = true
        // 隱藏導覽列
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Helvetica-Bold", size: 45.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60),
                NSAttributedString.Key.font: customFont
            ]
        }
        navigationController?.hidesBarsOnSwipe = true
        
        
        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
        }
        
        do {
            try fetchResultController.performFetch()
            if let fetchedObjects = fetchResultController.fetchedObjects {
                restaurants = fetchedObjects
            }
        } catch {
            print(error)
        }
        
    }
    
    // 建立過濾的方法
    func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 處理可以重建的任何資源
    }
    
    // 當一個視圖準備要顯示時，viewWillAppear 會被呼叫
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // viewDidAppear 方法會自動由 iOS 呼叫
    override func viewDidAppear(_ animated: Bool) {
        
        // 從 UserDefaults 取得 hasViewedWalkthrough 鍵並檢查這個值
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        // 實例化控制器，false 才顯示
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion:  nil)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    

    // MARK: - Table view data source 表格視圖資料源

    // 表格設置時會被呼叫
    override func numberOfSections(in tableView: UITableView) -> Int {
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }
   
    // 設定表格內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        // 判斷是從搜尋結果或是原來的陣列來取得餐廳
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // 設定 cell
       
        cell.nameLabel.text = restaurant.name
        if let restaurantImage = restaurant.image {
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        // 打卡
        cell.heartImageView.isHidden = restaurant.isVisited ? false : true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - 向右滑動表格
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 打卡動作
        let checkInAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            // 按下按鈕 true 變 false , false 變 true
            
            self.restaurants[indexPath.row].isVisited = self.restaurants[indexPath.row].isVisited ? false : true
            
            // 到訪過不隱藏小標誌
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? false : true
            
            
            
            // 呼叫完成處理器來取消動作按鈕
            completionHandler(true)
        }
        
        // 到訪過變取消符號，沒到訪過變打勾符號
        let checkInIcon = restaurants[indexPath.row].isVisited ? "arrow.uturn.left" : "checkmark"
        checkInAction.image = UIImage(systemName: checkInIcon)
        checkInAction.backgroundColor = UIColor(red: 38, green: 162, blue: 78)
        
        // 向右滑的按鈕
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        return swipeConfiguration
    }
    
    
    // ㄈ            Ｚ
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // （向左滑）刪除按鈕
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
                appDelegate.saveContext()
            }
            
            // 呼叫完成處理器來取消動作按鈕
            completionHandler(true)
        }
        
        
        // （向左滑）分享按鈕
        let shareAction = UIContextualAction(style: .normal, title: nil) {
            (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name!
            
            // 分享頁面
            let activityController : UIActivityViewController
            
            // 如果照片不為 nil，分享照片
            if let restaurantImage = self.restaurants[indexPath.row].image,
                let imageToShare = UIImage(data: restaurantImage as Data) {
                    activityController = UIActivityViewController(activityItems: [defaultText,imageToShare], applicationActivities: nil)
            } else {
                    activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                }
            
            // iPad
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(systemName: "trash")
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        // 向左滑動的兩個按鈕
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
    }

    
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }


    
}
