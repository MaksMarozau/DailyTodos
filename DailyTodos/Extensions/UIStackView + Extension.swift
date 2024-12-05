//
//  UIStackView + Extension.swift
//  DailyTodos
//
//  Created by Maks on 5.12.24.
//

import UIKit.UIStackView

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach({ addArrangedSubview($0) })
    }
}
