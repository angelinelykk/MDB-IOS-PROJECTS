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
    
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var creator: String? {
        didSet {
            guard let creator = creator else {return}
            
            let completion:(String)->Void = { creator in
                DispatchQueue.main.async {
                    self.creatorLabel.text = creator
                }
            }
            DispatchQueue.global(qos: .utility).async {
                completion(creator)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //image
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: contentView.center.x - contentView.bounds.width/16*7, y: contentView.center.y - contentView.bounds.height/16*7,width: contentView.bounds.width/8*7, height: contentView.bounds.height/8*7)
        
        //name label
        contentView.addSubview(nameLabel)
        contentView.addSubview(creatorLabel)
        
        NSLayoutConstraint.activate([
        
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height/16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            creatorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height/16 * 15),
            creatorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
}
