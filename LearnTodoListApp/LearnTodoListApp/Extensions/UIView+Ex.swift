//
//  UIView+Ex.swift
//  LearnTodoListApp
//
//  Created by Roman Knuyh on 8.02.21.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
