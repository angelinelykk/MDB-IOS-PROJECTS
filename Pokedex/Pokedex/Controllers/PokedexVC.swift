//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Pokedex"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 80, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        //add welcome label to welcome page
        
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
        
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UIView.animate(withDuration: 3.0, animations: {self.welcomeLabel.center.y += self.view.bounds.height/8*3}, completion: {(finished: Bool) in
            self.moveToIntro()
        })
    }
    
    func moveToIntro() {
        let vc = UINavigationController(rootViewController: IntroductionVC())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
        
    }
    
}

