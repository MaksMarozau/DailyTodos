//
//  TaskMenuView.swift
//  DailyTodos
//
//  Created by Maks on 4.12.24.
//

import UIKit

//MARK: - Task menu view protocols
protocol TaskMenuViewInputProtocol: AnyObject {
    func showError(error: CoreDataErrorService)
}

protocol TaskMenuViewOutputProtocol: AnyObject {
    func closePage()
    func editCurrentTask(task: TodoResult.Todo)
    func deleteCurrentTask(task: TodoResult.Todo)
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
    private let editTaskButton = UIButton()
    private let shareTaskButton = UIButton()
    private let deleteTaskButton = UIButton()
    private let buttonsStackVew = UIStackView()
    
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
        setTargets()
    }
    
    //MARK: - Configurations of Navigation bar
    private func configureNavBar() {
        
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        view.addSubviews(blurEffectView, taskInfoContainerView, menuContainerView)
        taskInfoContainerView.addSubviews(taskTitleLabel, taskDescriptionLabel, taskUserIdLabel)
        menuContainerView.addSubview(buttonsStackVew)
        buttonsStackVew.addArrangedSubviews(editTaskButton, shareTaskButton, deleteTaskButton)
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
        
        buttonsStackVew.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackVew.topAnchor.constraint(equalTo: menuContainerView.topAnchor).isActive = true
        buttonsStackVew.bottomAnchor.constraint(equalTo: menuContainerView.bottomAnchor).isActive = true
        buttonsStackVew.leadingAnchor.constraint(equalTo: menuContainerView.leadingAnchor).isActive = true
        buttonsStackVew.trailingAnchor.constraint(equalTo: menuContainerView.trailingAnchor).isActive = true
    }
    
    //MARK: - Configuration of User Interface
    private func configureUI() {
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        closePageGesture.addTarget(self, action: #selector(closePageGestureTapped))
        
        taskInfoContainerView.backgroundColor = UIColor.frameFill
        taskInfoContainerView.layer.cornerRadius = 12
        taskInfoContainerView.clipsToBounds = true
        
        menuContainerView.backgroundColor = UIColor.lightGray
        menuContainerView.layer.cornerRadius = 12
        menuContainerView.clipsToBounds = true

        
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
        
        buttonsStackVew.axis = .vertical
        buttonsStackVew.distribution = .fillEqually
        buttonsStackVew.backgroundColor = UIColor.frameFill
        buttonsStackVew.spacing = 1
        
        var editButtonConfig = UIButton.Configuration.plain()
        editButtonConfig.title = "Edit"
        editButtonConfig.image = UIImage(systemName: "square.and.pencil")?.withTintColor(UIColor.darkGrayText, renderingMode: .alwaysOriginal)
        editButtonConfig.background.backgroundColor = UIColor.lightGray
        editButtonConfig.baseForegroundColor = UIColor.darkGrayText
        editButtonConfig.imagePadding = 165
        editButtonConfig.imagePlacement = .trailing
        editButtonConfig.cornerStyle = .fixed
        editTaskButton.configuration = editButtonConfig
        
        var shareButtonConfig = UIButton.Configuration.plain()
        shareButtonConfig.title = "Share"
        shareButtonConfig.image = UIImage(systemName: "square.and.arrow.up")?.withTintColor(UIColor.darkGrayText, renderingMode: .alwaysOriginal)
        shareButtonConfig.background.backgroundColor = UIColor.lightGray
        shareButtonConfig.baseForegroundColor = UIColor.darkGrayText
        shareButtonConfig.imagePadding = 150
        shareButtonConfig.imagePlacement = .trailing
        shareButtonConfig.cornerStyle = .fixed
        shareTaskButton.configuration = shareButtonConfig
        
        var deleteButtonConfig = UIButton.Configuration.plain()
        deleteButtonConfig.title = "Delete"
        deleteButtonConfig.image = UIImage(systemName: "trash")?.withTintColor(UIColor.red, renderingMode: .alwaysOriginal)
        deleteButtonConfig.background.backgroundColor = UIColor.lightGray
        deleteButtonConfig.baseForegroundColor = UIColor.red
        deleteButtonConfig.imagePadding = 145
        deleteButtonConfig.imagePlacement = .trailing
        deleteButtonConfig.cornerStyle = .fixed
        deleteTaskButton.configuration = deleteButtonConfig
    }
    
    //MARK: - Set targets
    private func setTargets() {
        editTaskButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        shareTaskButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        deleteTaskButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Action API
    @objc private func closePageGestureTapped() {
        presenter?.closePage()
    }
    
    @objc private func editButtonTapped() {
        presenter?.editCurrentTask(task: todo)
    }
    
    @objc private func shareButtonTapped() {
        print("Don't availiable")
    }
    
    @objc private func deleteButtonTapped() {
        presenter?.deleteCurrentTask(task: todo)
    }
}

//MARK: - Implemendation of Input protocol
extension TaskMenuView: TaskMenuViewInputProtocol {
    func showError(error: CoreDataErrorService) {
        switch error {
        case .initCoreDataError:
            print("CoreData was not initialized")
        case .entityError:
            print("CoreData error: Entity not found")
        case .saveError:
            print("CoreData error: Save was failed")
        case .castError:
            print("CoreData error: Cast was failed")
        case .loadError:
            print("CoreData error: Load was failed")
        case .objectNotFoundError:
            print("CoreData error: Object not found")
        case .updateTaskStatusError:
            print("CoreData error: Task status updating was failed")
        case .fetchEntityCountError:
            print("CoreData error: entity counting was failed")
        }
    }
}
