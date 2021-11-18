//
//  TestVC.swift
//  MDB Social
//
//  Created by Angeline Lee on 1/11/21.
//

import Foundation
import UIKit

class TestVC: UIViewController {
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
    
    
    
    override func viewDidLoad() {
        
        view.backgroundColor = .black
    }
    
}
