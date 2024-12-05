//
//  Extensions.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import UIKit.UIView

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
}
