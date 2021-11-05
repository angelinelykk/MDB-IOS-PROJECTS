//
//  evenCell.swift
//  MDB Social
//
//  Created by Angeline Lee on 4/11/21.
//

import Foundation
import UIKit

class eventCell: UICollectionViewCell {
    static let reuseIdentifier = "eventCell"
    

    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var name: String? {
        didSet {
            guard let name = name else {return}
            
            let completion:(String)->Void = { name in
                DispatchQueue.main.async {
                    self.nameLabel.text = name
                }
            }
            DispatchQueue.global(qos: .utility).async {
                completion(name)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height/16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
}
