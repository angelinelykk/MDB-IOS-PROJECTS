//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Angeline Lee on 17/10/21.
//

import UIKit
class PokemonCell: UICollectionViewCell {
    static let reuseIdentifier = "pokemonCell"
    
    var pokemon: Pokemon = PokemonGenerator.shared.getPokemonArray()[0]
    
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
        label.text = " "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idLabel: UILabel = {
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
    
    
    var id: Int? {
        didSet {
            guard let id = id else {return}
            
            let completion:(Int)->Void = { name in
                DispatchQueue.main.async {
                    self.idLabel.text = String(id)
                }
            }
            
            DispatchQueue.global(qos: .utility).async {
                completion(id)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: contentView.center.x - contentView.bounds.width/16*7, y: contentView.center.y - contentView.bounds.height/16*7,width: contentView.bounds.width/8*7, height: contentView.bounds.height/8*7)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height/16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height/16),
            idLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
