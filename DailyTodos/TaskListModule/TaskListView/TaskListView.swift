//
//  ViewController.swift
//  DailyTodos
//
//  Created by Maks on 26.11.24.
//

import UIKit

protocol TaskListViewInputProtocol: AnyObject {
    func showTodos(_ todos: [TodoResult.Todo])
    func showError(_ error: Error)
}

protocol TaskListViewOutputProtocol: AnyObject {
    func loadData() async
}


//MARK: - TaskListView
final class TaskListView: UIViewController {

    //MARK: - Properties of class
    private let headerLabel = UILabel()
    private let footerView = UIView()
    private let footerLabel = UILabel()
    private let taskCountLabel = UILabel()
    private let searchTextField = UITextField()
    private let tasksTableView = UITableView()
    private let searchButton = UIButton()
    private let voiceButton = UIButton()
    private let leftContainerView = UIView()
    private let rightContainerView = UIView()
    private let loadingIndicator = UIActivityIndicatorView()
    
    private var todoListArray: [TodoResult.Todo] = []
    var presenter: TaskListViewOutputProtocol?
    
    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        addSubviews()
        setConstraintes()
        setupUI()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadIndicatorAction()
    }

    //MARK: - Add subviews
    private func addSubviews() {
        view.addSubviews(headerLabel, taskCountLabel, searchTextField, tasksTableView, footerView, loadingIndicator)
        leftContainerView.addSubview(searchButton)
        rightContainerView.addSubview(voiceButton)
        footerView.addSubview(footerLabel)
    }
    
    //MARK: - Initial setup for tableView
    private func initializeTableView() {
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    //MARK: - Set constraintes
    private func setConstraintes() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        leftContainerView.translatesAutoresizingMaskIntoConstraints = false
        leftContainerView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        leftContainerView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        rightContainerView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        rightContainerView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerYAnchor.constraint(equalTo: leftContainerView.centerYAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor, constant: 6).isActive = true
        
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.centerYAnchor.constraint(equalTo: rightContainerView.centerYAnchor).isActive = true
        voiceButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor, constant: -6).isActive = true
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
        footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        tasksTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16).isActive = true
        tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tasksTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    //MARK: - Setup views UI
    private func setupUI() {
        view.backgroundColor = UIColor.black

        headerLabel.textColor = UIColor.lightGrayText
        headerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        headerLabel.textAlignment = .left
        headerLabel.text = "Tasks"
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = UIColor.darkGrayText
        searchButton.isEnabled = false
        
        voiceButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        voiceButton.tintColor = UIColor.darkGrayText
        
        searchTextField.backgroundColor = UIColor.frameFill
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = UIColor.lightGrayText
        searchTextField.leftView = leftContainerView
        searchTextField.leftViewMode = .always
        searchTextField.rightView = rightContainerView
        searchTextField.rightViewMode = .always
        let placeholderColor = UIColor.darkGrayText
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        footerView.backgroundColor = UIColor.frameFill
        
        footerLabel.textColor = UIColor.lightGrayText
        footerLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        footerLabel.textAlignment = .center
        footerLabel.text = "\(todoListArray.count) Tasks"
        
        tasksTableView.backgroundColor = UIColor.clear
        tasksTableView.rowHeight = 106
        
        loadingIndicator.style = .large
        loadingIndicator.color = UIColor.lightGrayText
        loadingIndicator.hidesWhenStopped = true
    }
    
    //MARK: - Add targets
    private func addTargets() {
        searchButton.addTarget(self, action: #selector(serchButtonTaped), for: .touchUpInside)
        voiceButton.addTarget(self, action: #selector(voiceButtonTaped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textEditing), for: .editingChanged)
    }
    
    //MARK: - Buttons API
    @objc private func serchButtonTaped() {
        
    }
    
    @objc private func voiceButtonTaped() {
        //the voiсe logic may be here
        voiceButton.isSelected.toggle()
        if voiceButton.isSelected {
            voiceButton.tintColor = UIColor.lightGrayText
        } else {
            voiceButton.tintColor = UIColor.darkGray
        }
    }
    
    @objc private func textEditing() {
        if let text = searchTextField.text, text.isEmpty {
            searchButton.isEnabled = false
            searchButton.tintColor = UIColor.darkGrayText
        } else {
            searchButton.isEnabled = true
            searchButton.tintColor = UIColor.lightGrayText
        }
    }
    
    //MARK: - Output
    private func start() {
        Task {
            await presenter?.loadData()
        }
    }
    
    //MARK: - Animation
    private func loadIndicatorAction() {
        loadingIndicator.startAnimating()
    }
}


//MARK: - TableView's delegate and data source implemendation
extension TaskListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = todoListArray[indexPath.row]
        let todoID = todo.id
        let description = todo.todo
        let userId = todo.userId
        let status = todo.completed
        
        guard let cell = tasksTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.setData(with: todoID, description, userId, status)
        return cell
    }
}


//MARK: - Input protocol implemendation
extension TaskListView: TaskListViewInputProtocol {
    func showTodos(_ todos: [TodoResult.Todo]) {
        todoListArray = todos
        
        DispatchQueue.main.async {
            self.footerLabel.text = "\(self.todoListArray.count) Tasks"
            self.tasksTableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func showError(_ error: any Error) {
        let currentError = error as? ErrorService
        switch currentError {
        case .badURL:
            print("Bad URL")
        case .badRequest:
            print("Bad Request")
        case .badResponce:
            print("Bad Responce")
        case .invalidData:
            print("No Data")
        case .none:
            break
        }
    }
    
    
}
