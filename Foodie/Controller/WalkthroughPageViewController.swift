//
//  WalkthroughPageViewController.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/7/31.
//

import UIKit


protocol WalkthroughPageViewControllerDelegate: AnyObject {
    // 告訴它的委派目前的頁面所引，這個委派可以更新頁面指示器
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
    
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide", "Search and locate your favorite restaurants on Maps", "Find restaurants shared by your friends and other foodies"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        // 將資料源設定為自己
        dataSource = self
        
        // 建立第一個導覽畫面
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // 如果採用 UIPageViewControllerDelegate 協定，這個方法會在手勢所驅動的轉場完成後自動被呼叫
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // 檢查轉場是否完成
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                
                // 找出目前頁面的索引值
                currentIndex = contentViewController.index
                // 呼叫 didUpdatePageIndex 來通知這個委派
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
    
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController  = contentViewController(at: currentIndex) {
            
            // 呼叫內建的 setViewControllers 方法，並導覽至下一個視圖控制器
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        // 建立新的視圖控制器並傳遞適合的資料
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            // 依照頁面顯示不同內容
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    // UIPageViewControllerDataSourceu 的 protocol 需要的兩個方法
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 取得既定視圖控制器的目前頁面索引值
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        // 回傳給視圖控制器來顯示
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    

   
   

}
