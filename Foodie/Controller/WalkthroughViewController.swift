//
//  WalkthroughViewController.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/7/31.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds =  true
        }
    }
    
    @IBOutlet var skipButton: UIButton!
    
    var walkthroughPageViewControler: WalkthroughPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewControler = pageViewController
            walkthroughPageViewControler?.walkthroughDelegate = self
        }
    }
    
    func updateUI() {
        if let index = walkthroughPageViewControler?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
            default: break
            }
            
            pageControl.currentPage = index
        }
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        if let index = walkthroughPageViewControler?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewControler?.forwardPage()
        
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default: break
            }
        }
        
        updateUI()
    }
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion:  nil)
    }
    
}
