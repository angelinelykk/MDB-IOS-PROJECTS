//
//  IndividualVC.swift
//  MDB Social
//
//  Created by Angeline Lee on 14/11/21.
//

import Foundation
import UIKit

class IndividualVC: UIViewController {
    //rsvp button
    //delete button if owner of event
    
    //name of event
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //event image
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    var url: URL? {
        didSet {
            guard let url = url else {return}
            
            let completion:(UIImage)->Void = { image in
                DispatchQueue.main.async {
                self.imageView.image = image
                }
            }
            
            DispatchQueue.global(qos: .utility).async {
                guard let data = try? Data(contentsOf: url) else {return}
                completion(UIImage(data: data)!)
            }
        }
    }
    
    // description of event
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //name of member who posted
    
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // number of people who rsvpd
    
    private let rsvpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var event: SOCEvent?
    
    init(givenEvent: SOCEvent) {
        super.init(nibName: nil, bundle: nil)
        event = givenEvent
        self.nameLabel.text = "Name: " + givenEvent.name
        FIRDatabaseRequest.shared.getUser(uid: givenEvent.creator, completion: {user in self.creatorLabel.text = "Creator: " + user.fullname})
        self.descriptionLabel.text = "Description: " + givenEvent.description
        self.rsvpLabel.text = "RSVP: " + String(givenEvent.rsvpUsers.count)
        self.url = URL(string:givenEvent.photoURL)
    }
    
    private let returnButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Return", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Delete", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let rsvpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("RSVP", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Cancel", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setImageView()
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(creatorLabel)
        view.addSubview(rsvpLabel)
        view.addSubview(returnButton)
        view.addSubview(rsvpButton)
        
        if (event!.creator == SOCAuthManager.shared.currentUser!.uid) {
            view.addSubview(deleteButton)
            NSLayoutConstraint.activate([
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.bounds.width/4),
                deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 2)
            ])
        }
        
        if (event!.rsvpUsers.contains(SOCAuthManager.shared.currentUser!.uid!)) {
            
            view.addSubview(cancelButton)
            NSLayoutConstraint.activate([
                cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width/4),
                cancelButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 3)
            ])
        }
        
        NSLayoutConstraint.activate([
        
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 4),
            
            creatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creatorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 5),
            
            rsvpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rsvpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 6),
            
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.bounds.width/4),
            returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 7),
            
            rsvpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width/4),
            rsvpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8 * 7)
        ])
        
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        rsvpButton.addTarget(self, action: #selector(didTapRSVP(_:)), for: .touchUpInside)
    }
    
    @objc func didTapReturn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapRSVP(_ sender: UIButton) {
        print("rsvp")
        event?.rsvpUsers.append((SOCAuthManager.shared.currentUser?.uid)!)
        FIRDatabaseRequest.shared.setEvent(event!, completion: nil)
        self.rsvpLabel.text = "RSVP: " + String(event!.rsvpUsers.count)
        
    }
    
    func setImageView() {
        guard let url = url else {return}
        
        let completion:(UIImage)->Void = { image in
            DispatchQueue.main.async {
            self.imageView.image = image
            }
        }
        
        DispatchQueue.global(qos: .utility).async {
            guard let data = try? Data(contentsOf: url) else {return}
            completion(UIImage(data: data)!)
        }
        
        self.imageView.frame = CGRect(x: view.center.x - view.bounds.height/8, y:view.center.y - view.bounds.height/3, width: view.bounds.height/4, height: view.bounds.height/4)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
