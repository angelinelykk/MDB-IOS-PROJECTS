//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class IndividualVC: UIViewController {
    
    
    var imageView: UIImageView = {
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
    
    let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Return", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(givenPokemon: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        nameLabel.text = "Name: " + givenPokemon.name
        idLabel.text = "ID: " + String(givenPokemon.id)
        totalLabel.text = "Totak: " + String(givenPokemon.total)
        hpLabel.text = "HP: " + String(givenPokemon.health)
        attackLabel.text = "Attack: " + String(givenPokemon.attack)
        defenseLabel.text = "Defense: " + String(givenPokemon.defense)
        spAtkLabel.text = "Special Attack: " + String(givenPokemon.specialAttack)
        spDefLabel.text = "Special Defense: " + String(givenPokemon.specialDefense)
        speedLabel.text = "Speed: " + String(givenPokemon.speed)
        typeLabel.text = getTypeString(pokeTypes: givenPokemon.types)
        url = givenPokemon.imageUrl
    }
    
    func getTypeString(pokeTypes: [PokeType]) -> String {
        var returnString = "Type(s): "
        for pokeType in pokeTypes {
            returnString += pokeType.rawValue
            returnString += ", "
        }
        returnString.removeLast()
        returnString.removeLast()
        return returnString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Name: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "ID: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Type(s): "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Total: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let hpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "hp: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let attackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Attack: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let defenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Defense: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let spAtkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "SP(atk): "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let spDefLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "SP(def): "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Speed: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(totalLabel)
        view.addSubview(hpLabel)
        view.addSubview(attackLabel)
        view.addSubview(defenseLabel)
        view.addSubview(spAtkLabel)
        view.addSubview(spDefLabel)
        view.addSubview(speedLabel)
        setImageView()
        view.addSubview(imageView)
        view.addSubview(returnButton)
        view.addSubview(typeLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            idLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*10),
            idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            totalLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*11),
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*12),
            hpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            attackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*13),
            attackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            defenseLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*14),
            defenseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spAtkLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*15),
            spAtkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spDefLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*16),
            spDefLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            speedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*17),
            speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*18),
            typeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20*19),
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        /**view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(totalLabel)
        view.addSubview(hpLabel)
        view.addSubview(attackLabel)
        view.addSubview(spAtkLabel)
        view.addSubview(spDefLabel)
        view.addSubview(speedLabel)
         */
        /**
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/4),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/4),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/4),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/4),
            
            
        ])
        */
    }

    @objc func didTapReturn(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
    
}
