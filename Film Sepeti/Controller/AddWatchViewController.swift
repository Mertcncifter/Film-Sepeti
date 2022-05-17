//
//  AddMovieViewController.swift
//  Film Sepeti
//
//  Created by mert can çifter on 8.05.2022.
//

import UIKit
import CoreData

class AddWatchViewController: UIViewController {
    

    // MARK: - Properties
    
    var viewModel: AddWatchViewModelProtocol! {
        didSet {
                viewModel.delegate = self
        }
    }
    
    private lazy var movieNameContainerView: UIView = {
        let image = UIImage(systemName: "film.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        let view = CustomInput().inputContainerView(withImage: image!, textField: movieNameTextField)
        return view
    }()
    
    private lazy var movieLinkContainerView: UIView = {
        let image = UIImage(systemName: "link.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        let view = CustomInput().inputContainerView(withImage: image!, textField: movieLinkTextField)
        return view
    }()
    
    private lazy var movieTimeContainerView: UIView = {
        let image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        let view = CustomInput().inputContainerView(withImage: image!, textField: movieTimeTextField)
        return view
    }()
    
    private let movieNameTextField: UITextField = {
        let tf = CustomInput().textField(withPlaceholder: "Film Adı")
        return tf
    }()
    
    private let movieLinkTextField: UITextField = {
        let tf = CustomInput().textField(withPlaceholder: "Link")
        return tf
    }()
    
    private let movieTimeTextField: UITextField = {
        let tf = CustomInput().textField(withPlaceholder: "Ne zaman")
        tf.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction),datePickerMode: .dateAndTime)
        return tf
    }()
    
    private let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.load()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc
    func handleSave(){
        guard let name = movieNameTextField.text, !name.isEmpty else { return }
        guard let link = movieLinkTextField.text, !link.isEmpty else { return }
        viewModel.addWatch(name: name, link: link)
    }
    
    @objc
    func cancelAction() {
        movieTimeTextField.resignFirstResponder()
    }

    @objc
    func doneAction() {
        if let datePickerView = movieTimeTextField.inputView as? UIDatePicker {
            viewModel.changeWatch(date: datePickerView.date)
            movieTimeTextField.text = datePickerView.date.toString()
            movieTimeTextField.resignFirstResponder()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [movieNameContainerView,movieLinkContainerView,movieTimeContainerView,saveButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        
        stack.anchor(top : view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,
                     paddingTop: 50,
                     paddingLeft: 32,paddingRight: 32)
    }
}


extension AddWatchViewController: AddWatchViewModelDelegate {
    func handleViewModelOutput(_ output: AddWatchViewModelOutput) {
        switch output {
        case .setLoading(let bool):
            print("")
        case .firstLoad(let watch, let watchName):
            if watchName != nil {
                movieNameTextField.text = watchName
            }
            
            if watch != nil {
                movieNameTextField.text = watch?.name
                movieLinkTextField.text = watch?.link
                movieTimeTextField.text = watch?.date?.toString()
            }
        case .success:
            navigationController?.popViewController(animated: true)
        }
    }
}
