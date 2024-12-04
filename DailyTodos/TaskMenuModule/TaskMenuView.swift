//
//  TaskMenuView.swift
//  DailyTodos
//
//  Created by Maks on 4.12.24.
//

import UIKit

//MARK: - Task menu view protocols
protocol TaskMenuViewInputProtocol: AnyObject {
    
}

protocol TaskMenuViewOutputProtocol: AnyObject {
    func closePage()
}

//MARK: - Final class TaskMenuView
final class TaskMenuView: UIViewController {
    
    //MARK: - Properties of class
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let closePageGesture = UITapGestureRecognizer()
    private let taskInfoContainerView = UIView()
    private let menuContainerView = UIView()
    private let taskTitleLabel = UILabel()
    private let taskDescriptionLabel = UILabel()
    private let taskUserIdLabel = UILabel()
    
    private let todo: TodoResult.Todo
    var presenter: TaskMenuViewOutputProtocol?
    
    //MARK: - Initializators
    init(todo: TodoResult.Todo)  {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle of controller
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraintes()
        configureUI()
    }
    
    //MARK: - Configurations of Navigation bar
    private func configureNavBar() {
        
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        view.addSubviews(blurEffectView, taskInfoContainerView, menuContainerView)
        taskInfoContainerView.addSubviews(taskTitleLabel, taskDescriptionLabel, taskUserIdLabel)
        blurEffectView.addGestureRecognizer(closePageGesture)
    }
    
    //MARK: - Setting of constraintes
    private func setConstraintes() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = view.bounds
        
        taskInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        taskInfoContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 53).isActive = true
        taskInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        taskInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        taskInfoContainerView.heightAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true
        
        menuContainerView.translatesAutoresizingMaskIntoConstraints = false
        menuContainerView.topAnchor.constraint(equalTo: taskInfoContainerView.bottomAnchor, constant: 16).isActive = true
        menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 53).isActive = true
        menuContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -53).isActive = true
        menuContainerView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTitleLabel.topAnchor.constraint(equalTo: taskInfoContainerView.topAnchor, constant: 12).isActive = true
        taskTitleLabel.leadingAnchor.constraint(equalTo: taskInfoContainerView.leadingAnchor, constant: 16).isActive = true
        taskTitleLabel.trailingAnchor.constraint(equalTo: taskInfoContainerView.trailingAnchor, constant: 16).isActive = true
        taskTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        taskUserIdLabel.translatesAutoresizingMaskIntoConstraints = false
        taskUserIdLabel.bottomAnchor.constraint(equalTo: taskInfoContainerView.bottomAnchor, constant: -12).isActive = true
        taskUserIdLabel.leadingAnchor.constraint(equalTo: taskInfoContainerView.leadingAnchor, constant: 16).isActive = true
        taskUserIdLabel.trailingAnchor.constraint(equalTo: taskInfoContainerView.trailingAnchor, constant: 16).isActive = true
        taskUserIdLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        taskDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 6).isActive = true
        taskDescriptionLabel.bottomAnchor.constraint(equalTo: taskUserIdLabel.topAnchor, constant: -6).isActive = true
        taskDescriptionLabel.leadingAnchor.constraint(equalTo: taskInfoContainerView.leadingAnchor, constant: 16).isActive = true
        taskDescriptionLabel.trailingAnchor.constraint(equalTo: taskInfoContainerView.trailingAnchor, constant: 16).isActive = true
    }
    
    //MARK: - Configuration of User Interface
    private func configureUI() {
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        closePageGesture.addTarget(self, action: #selector(closePageGestureTapped))
        
        taskInfoContainerView.backgroundColor = UIColor.frameFill
        taskInfoContainerView.layer.cornerRadius = 12
        
        menuContainerView.backgroundColor = UIColor.lightGray
        menuContainerView.layer.cornerRadius = 12
        
        taskTitleLabel.textAlignment = .left
        taskTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        taskTitleLabel.textColor = UIColor.lightGrayText
        taskTitleLabel.text = "Task number: \(todo.id)"
        
        taskDescriptionLabel.textAlignment = .left
        taskDescriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        taskDescriptionLabel.textColor = UIColor.lightGrayText
        taskDescriptionLabel.numberOfLines = 0
        taskDescriptionLabel.text = "\(todo.todo)"
        
        taskUserIdLabel.textAlignment = .left
        taskUserIdLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        taskUserIdLabel.textColor = UIColor.darkGrayText
        taskUserIdLabel.text = "User ID: \(todo.userId)"
    }
    
    //MARK: - Action API
    @objc private func closePageGestureTapped() {
        presenter?.closePage()
    }
}

//MARK: - Implemendation of Input protocol
extension TaskMenuView: TaskMenuViewInputProtocol {
    
}
