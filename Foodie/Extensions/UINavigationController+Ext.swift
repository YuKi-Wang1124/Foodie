//
//  UINavigationController+Ext.swift
//  Foodie
//
//  Created by 王昱淇 on 2022/6/9.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
