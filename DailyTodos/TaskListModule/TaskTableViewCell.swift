//
//  TaskTableViewCell.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
 
    //MARK: - Properties
    private let containerView = UIView()
    
    
    //MARK: - Initializators
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        contentView.addSubview(containerView)
    }
    
    //MARK: - Set constraintes
    private func setConstraintes() {
        
    }
    
    //MARK: - Setup subviews UI
    private func setupUI () {
        
    }
}
