//
//  NewTaskView.swift
//  DailyTodos
//
//  Created by Maks on 2.12.24.
//

import UIKit

//MARK: - New task view protocols
protocol NewTaskViewInputProtocol: AnyObject {
    func updatePage()
    func showError(error: CoreDataErrorService)
    func backlightEmptyField(by error: InterfaceSaveErrorService)
}

protocol NewTaskViewOutputProtocol: AnyObject {
    func homeTransition()
    func saveTask(with taskID: Int, _ description: String?, _ userID: Int?)
}


//MARK: New task view
final class NewTaskView: UIViewController {
    
    //MARK: - Properties
    private let taskNumberLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let choiseUserButton = UIButton()
    private let userIDLabel = UILabel()
    private let forUserPicker = UIPickerView()
    
    private var choisedUserID = Int()
    var taskNumber = Int()
    
    var presenter: NewTaskViewOutputProtocol?
    
    //MARK: - Life cicles
    override func viewDidLoad() {
        super.viewDidLoad()
        adddSubviews()
        setConstraintes()
        setupUI()
        appointmentExecutors()
        addTargets()
        setupNaviBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forUserPicker.layer.cornerRadius = forUserPicker.frame.height / 2
        forUserPicker.clipsToBounds = true
    }
    
    //MARK: - Setup navigation bar
    private func setupNaviBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Home", for: .normal)
        backButton.setTitleColor(UIColor.gold, for: .normal)
        backButton.tintColor = UIColor.gold
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside) // Действие
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)

        let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    //MARK: - Add subviews
    private func adddSubviews() {
        view.addSubviews(taskNumberLabel, descriptionTextView, choiseUserButton, userIDLabel, forUserPicker)
    }
    
    //MARK: - Set constraintes
    private func setConstraintes() {
        taskNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        taskNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        taskNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        taskNumberLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        choiseUserButton.translatesAutoresizingMaskIntoConstraints = false
        choiseUserButton.topAnchor.constraint(equalTo: taskNumberLabel.bottomAnchor, constant: 16).isActive = true
        choiseUserButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        choiseUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        choiseUserButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false
        userIDLabel.centerYAnchor.constraint(equalTo: choiseUserButton.centerYAnchor).isActive = true
        userIDLabel.leadingAnchor.constraint(equalTo: choiseUserButton.trailingAnchor, constant: 8).isActive = true
        
        forUserPicker.translatesAutoresizingMaskIntoConstraints = false
        forUserPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forUserPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        forUserPicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        forUserPicker.heightAnchor.constraint(equalTo: forUserPicker.widthAnchor, multiplier: 1).isActive = true
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: choiseUserButton.bottomAnchor, constant: 16).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        taskNumberLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        taskNumberLabel.textAlignment = .left
        taskNumberLabel.textColor = UIColor.lightGrayText
        taskNumberLabel.numberOfLines = 1
        taskNumberLabel.text = "Task number: \(taskNumber)"
        
        choiseUserButton.setTitle("for User:", for: .normal)
        choiseUserButton.setTitleColor(UIColor.blue, for: .normal)
        choiseUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        
        userIDLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        userIDLabel.textAlignment = .left
        userIDLabel.textColor = UIColor.lightGrayText
        userIDLabel.numberOfLines = 1
        
        descriptionTextView.backgroundColor = UIColor.clear
        descriptionTextView.textColor = .darkGrayText
        descriptionTextView.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.text = "Enter the description"
        addTextViewToolBar()
        
        forUserPicker.backgroundColor = UIColor.clear
        forUserPicker.isHidden = true
    }
    
    private func addTextViewToolBar() {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Ready", style: .done, target: self, action: #selector(hideKeyboard))
        toolbar.sizeToFit()
        toolbar.items = [doneButton]
        descriptionTextView.inputAccessoryView = toolbar
    }
    
    //MARK: - Executors
    private func appointmentExecutors() {
        forUserPicker.delegate = self
        forUserPicker.dataSource = self
        
        descriptionTextView.delegate = self
    }
    
    //MARK: - Add targets
    private func addTargets() {
        choiseUserButton.addTarget(self, action: #selector(choiseUserButtonTaped), for: .touchUpInside)
    }
    
    //MARK: - Selector API
    @objc private func choiseUserButtonTaped()  {
        view.endEditing(true)
        forUserPicker.isHidden = false
    }
    
    @objc private func hideKeyboard() {
        forUserPicker.isHidden = true
        view.endEditing(true)
    }
    
    @objc private func backButtonTapped() {
        presenter?.homeTransition()
    }
    
    @objc private func saveButtonTapped() {
        let description = descriptionTextView.text
        presenter?.saveTask(with: taskNumber, description, choisedUserID)
    }
    
    //MARK: - Animation backlight
    private func backlightField(for view: UIView) {
        let backlightColor = UIColor.gold
        view.backgroundColor = backlightColor
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            view.backgroundColor = .clear
        }
    }
}


//MARK: - Picker view protocols implemendation
extension NewTaskView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "\(row + 1)"
        label.textColor = UIColor.lightGrayText
        label.font = UIFont.systemFont(ofSize: 42, weight: .semibold)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choisedUserID = row + 1
        userIDLabel.text = "\(choisedUserID)"
        forUserPicker.isHidden = true
    }
}


//MARK: - Text view's protocol implemendation
extension NewTaskView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "Enter the description" {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .lightGrayText
            descriptionTextView.textAlignment = .left
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Enter the description"
            descriptionTextView.textColor = .darkGrayText
            descriptionTextView.textAlignment = .left
        }
    }
}


//MARK: - Input protocol implemendation
extension NewTaskView: NewTaskViewInputProtocol {
    func showError(error: CoreDataErrorService) {
        print(error)
    }
    
    func backlightEmptyField(by error: InterfaceSaveErrorService) {
        switch error {
        case .noUserID:
            backlightField(for: choiseUserButton)
        case .noDescription:
            backlightField(for: descriptionTextView)
        }
    }
    
    func updatePage() {
        choisedUserID = 0
        taskNumber += 1
        taskNumberLabel.text = "Task number: \(taskNumber)"
        userIDLabel.text = ""
        descriptionTextView.text = "Enter the description"
        descriptionTextView.textColor = .darkGrayText
    }
}
