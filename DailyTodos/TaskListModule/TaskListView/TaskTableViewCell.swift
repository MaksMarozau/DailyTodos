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
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let userIDLabel = UILabel()
    private let compleationButton = UIButton()
    private let separatorView = UIView()
    
    private var isCompleted = Bool()
    private var title = String()
    private var taskID = Int()
    
    var changeTasksStatusAction: ((_ statusToChange: Bool, _ taskId: Int) -> Void)?
    
    //MARK: - Initializators
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraintes()
        setupUI()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCompleted = false
        title = ""
        taskID = 0
        titleLabel.attributedText = nil
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubviews(compleationButton, titleLabel, descriptionLabel, userIDLabel, separatorView)
    }
    
    //MARK: - Set constraintes
    private func setConstraintes() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        compleationButton.translatesAutoresizingMaskIntoConstraints = false
        compleationButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        compleationButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        compleationButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        compleationButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: compleationButton.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: compleationButton.trailingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false
        userIDLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6).isActive = true
        userIDLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12).isActive = true
        userIDLabel.leadingAnchor.constraint(equalTo: compleationButton.trailingAnchor, constant: 8).isActive = true
        userIDLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //MARK: - Setup subviews UI
    private func setupUI () {
        containerView.backgroundColor = UIColor.clear
        
        compleationButton.imageEdgeInsets = UIEdgeInsets(top: -53, left: 0, bottom: 0, right: 0)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .left
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 2
        
        userIDLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        userIDLabel.textAlignment = .left
        
        separatorView.backgroundColor = UIColor.darkGrayText
    }
    
    //MARK: - Add targets
    private func addTargets() {
        compleationButton.addTarget(self, action: #selector(changeTaskStatus), for: .touchUpInside)
    }
    
    //MARK: - Button API
    @objc private func changeTaskStatus() {
        changeTasksStatusAction?(isCompleted, taskID)
    }
    
    //MARK: - Update cell's style
    private func updateStyleWithCompleationStatus() {
        if isCompleted {
            compleationButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            compleationButton.tintColor = UIColor.gold
            
            let attributedTitleText = NSAttributedString(string: title, attributes: [
                .strikethroughStyle : NSUnderlineStyle.single.rawValue,
                .foregroundColor : UIColor.darkGrayText
            ])
            titleLabel.attributedText = attributedTitleText
            
            descriptionLabel.textColor = UIColor.darkGrayText
            
            userIDLabel.textColor = UIColor.darkGrayText
            
        } else {
            compleationButton.setImage( UIImage(systemName: "circle"), for: .normal)
            compleationButton.tintColor = UIColor.darkGrayText
            
            titleLabel.textColor = UIColor.lightGrayText
            titleLabel.text = title
            
            descriptionLabel.textColor = UIColor.lightGrayText
            
            userIDLabel.textColor = UIColor.lightGrayText
        }
    }
    
    //MARK: - Set data
    func setData(with taskID: Int, _ description: String, _ userID: Int, _ completedStatus: Bool) {
        isCompleted = completedStatus
        title = "Task number: \(taskID)"
        descriptionLabel.text = description
        userIDLabel.text = "user ID: \(userID)"
        self.taskID = taskID
        
        updateStyleWithCompleationStatus()
    }
}
