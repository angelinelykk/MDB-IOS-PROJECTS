//
//  SocialCreationVC.swift
//  MDB Social
//
//  Created by Angeline Lee on 11/11/21.
//

import UIKit
import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SocialCreationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var eventImage: UIImage?
    
    var startDateLocal: String?
    
    var startDate: Date?
    
    var endDateLocal: String?
    
    var ImageData: Data?
    
    var ImageURL: URL?
    
    var endDate: Date?
    
    var eventName: String?
    
    var eventDescription: String?
    //name
    private let nameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Name of event:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //short description
    private let descriptionTextField: AuthTextField = {
        let tf = AuthTextField(title: "Description of event:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //image - to call function when button is tapped
    
    //button for picture from camera
    //button for picture from library
    
    private let cameraButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Camera", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let libraryButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Upload from library", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let createButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Create", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let returnButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Return", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            ip.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        ip.allowsEditing = true
        return ip
    }()
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("done")
        guard let image = info[.editedImage] as? UIImage else { return }
        self.eventImage = image
        let imageName = UUID().uuidString
        
        if let jpegData = image.jpegData(compressionQuality: 0.001) {
            ImageData = jpegData
        }

        dismiss(animated: true)

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //startdate
    private let startDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.dateAndTime
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.timeZone = TimeZone(secondsFromGMT: -8 * 60 * 60)
        return dp
    }()
    
    //enddate
    private let endDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.dateAndTime
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.timeZone = TimeZone(secondsFromGMT: -8 * 60 * 60)
        return dp
    }()
    
    //connect action method to date picker
    @objc func receivedStartDate(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "PST")
            self.startDateLocal = dateFormatter.string(from: sender.date)
            self.startDate = sender.date
        }
        print(self.startDateLocal)
    }
    
    @objc func receivedEndDate(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "PST")
            self.endDateLocal = dateFormatter.string(from: sender.date)
            self.endDate = sender.date
        }
        print(self.endDateLocal)
    }
    
    @objc func didTapCamera(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func didTapLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func didTapCreate(_ sender: UIButton) {
        print("tapped")
        eventName = nameTextField.text
        eventDescription = descriptionTextField.text
        let myTimeStamp = Timestamp(date: self.startDate!)
        FIRDatabaseRequest.shared.uploadImage(imageData: ImageData!, name: eventName!, completion: {url in
            self.ImageURL = url
            print(url)
            print("help")
            
            
            let newEvent = SOCEvent(name: self.eventName!, description: self.eventDescription!, photoURL: self.ImageURL!.absoluteString, startTimeStamp: myTimeStamp, creator: (SOCAuthManager.shared.currentUser?.uid)!, rsvpUsers: [])
            FIRDatabaseRequest.shared.setEvent(newEvent, completion: nil)
        })
    }
    
    @objc func didTapReturn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //connect action method to date picker
        
        startDatePicker.addTarget(self, action: #selector(receivedStartDate(_:)), for: .valueChanged)
        
        endDatePicker.addTarget(self, action: #selector(receivedEndDate(_:)), for: .valueChanged)
        //set the autolayout rules to govern the positon of the date picker
        
        view.addSubview(startDatePicker)
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8)
        ])
        view.addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8*2)
        ])
        
        NSLayoutConstraint.activate([
            startDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startDatePicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8*3)
        ])
        
        view.addSubview(endDatePicker)
        
        NSLayoutConstraint.activate([
            endDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endDatePicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8 * 4)
        ])
        
        view.addSubview(cameraButton)
        view.addSubview(libraryButton)
        
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8 * 5)
        ])
        
        NSLayoutConstraint.activate([
            libraryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            libraryButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8 * 6)
        ])
        
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(view.bounds.width/4)),
            createButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8 * 7)
        ])
        
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width/4),
            returnButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/8 * 7)
        ])
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        
        
        cameraButton.addTarget(self, action: #selector(didTapCamera(_:)), for: .touchUpInside)
        libraryButton.addTarget(self, action: #selector(didTapLibrary(_:)), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate(_:)), for: .touchUpInside)
    }
}



