//
//  FilterVC.swift
//  Pokedex
//
//  Created by Angeline Lee on 17/10/21.
//

import UIKit

class FilterVC: UIViewController {
    
    /**case Bug
     case Grass
     case Dark
     case Ground
     case Dragon
     case Ice
     case Electric
     case Normal
     case Fairy
     case Poison
     case Fighting
     case Psychic
     case Fire
     case Rock
     case Flying
     case Steel
     case Ghost
     case Water
     case Unknown*/

    
    let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Return", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var buttons: [UIButton] = []
    
    let possible_types: [PokeType] = [.Bug, .Grass, .Dark, .Ground, .Dragon, .Ice, .Electric, .Normal, .Fairy, .Poison, .Fighting, .Psychic, .Fire, .Rock, .Flying, .Steel, .Ghost, .Water, .Unknown]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        for poke in possible_types {
            let pokeButton: UIButton = {
                let button = UIButton()
                button.setTitle(poke.rawValue, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.tintColor = .white
                button.backgroundColor = .systemOrange
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
        buttons.append(pokeButton)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*18),
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
    }
    
    
    @objc func didTapReturn(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
}

