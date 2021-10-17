//
//  FilterVC.swift
//  Pokedex
//
//  Created by Angeline Lee on 17/10/21.
//

import UIKit

class FilterVC: UIViewController {
    let pokemons = PokemonGenerator.shared.getPokemonArray()
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
    
    var selectedTypes: [PokeType] = []
    
    var resultPokemon: [Pokemon] = []
    
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select types then click here to filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        for index in 0..<(possible_types.count - 1) {
            let poke = possible_types[index]
            let pokeButton: UIButton = {
                let button = UIButton()
                button.setTitle(poke.rawValue, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.tintColor = .white
                button.backgroundColor = .black
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            buttons.append(pokeButton)
            pokeButton.tag = index
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(returnButton)
        view.addSubview(filterButton)
        
        for button in buttons[0..<buttons.count/2] {
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*CGFloat(button.tag*2+2)),
                button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/4)
            ])
        }
        
        for button in buttons[buttons.count/2+1..<buttons.count] {
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*CGFloat((button.tag-buttons.count/2)*2+2)),
                button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/4*3)
            ])
        }
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*19),
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        
        for button in buttons {
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
        
        filterButton.addTarget(self, action: #selector(didTapFilter(_:)), for: .touchUpInside)
    }
    
    
    @objc func didTapReturn(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        buttons[sender.tag].backgroundColor = .blue
        selectedTypes.append(possible_types[sender.tag])

    }
    @objc func didTapFilter(_ sender: UIButton) {
        for pokemon in pokemons {
            var toAdd:Bool = true
            for selected in selectedTypes {
                if !pokemon.types.contains(selected) {
                    toAdd = false
                }
            }
            if toAdd {
                resultPokemon.append(pokemon)
            }
        }
        print(resultPokemon)
        
        let vc = IntroductionVC()
        vc.displayResults = true
        vc.pokemons = resultPokemon
        vc.collectionView.reloadData()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

