//
//  ResultsVC.swift
//  Pokedex
//
//  Created by Angeline Lee on 17/10/21.
//

import UIKit

class ResultsVC: UIViewController {
    
    var pokemons2 = PokemonGenerator.shared.getPokemonArray()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
        
        //searchBar
        
        view.backgroundColor = .systemOrange
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width/4, height: view.bounds.width/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0))
        
        /**collectionView.collectionViewLayout = layout*/
        
        view.addSubview((collectionView))
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
    }
    
    
    func getPokemonInOrder(nationalNumber: Int) -> Pokemon {
        
        return pokemons2[nationalNumber]
        
    }
    
}

extension ResultsVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons2.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.url = pokemons2[indexPath.item].imageUrl
        cell.name = pokemons2[indexPath.item].name
        cell.id = pokemons2[indexPath.item].id
        cell.pokemon = pokemons2[indexPath.item]
        return cell
    }
}

extension ResultsVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! PokemonCell
        let vc = IndividualVC(givenPokemon: tappedCell.pokemon)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


