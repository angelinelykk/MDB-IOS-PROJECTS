//
//  Pokemon.swift
//  Pokedex
//
//  Created by Angeline Lee on 8/10/21.
//

import UIKit


class IntroductionVC: UIViewController, UISearchResultsUpdating {
    //array of dictionaries: data source
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    let searchController = UISearchController(searchResultsController: ResultsVC())
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        return collectionView
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.backgroundColor = .white
        
        
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
        
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        filterButton.addTarget(self, action: #selector(didTapFilter(_:)), for: .touchUpInside)
        
    }
    
    //search bar implemented
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        
        let vc = searchController.searchResultsController as?ResultsVC
        
        var results: [Pokemon] = []
        
        //results have been successfully obtained, but need to display them correctly.
        for pokemon in pokemons {
            if pokemon.name.contains(text) {
                results.append(pokemon)
            }
        }
        vc?.pokemons2 = results
        vc?.collectionView.reloadData()
        print(results)
        print(text)
    }
    
    func getPokemonInOrder(nationalNumber: Int) -> Pokemon {
        
        return pokemons[nationalNumber]
        
    }
    
    @objc func didTapFilter(_ sender: UIButton) {
        let vc = FilterVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}



extension IntroductionVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.url = pokemons[indexPath.item].imageUrl
        cell.name = pokemons[indexPath.item].name
        cell.id = pokemons[indexPath.item].id
        cell.pokemon = pokemons[indexPath.item]
        return cell
    }
}

extension IntroductionVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! PokemonCell
        let vc = IndividualVC(givenPokemon: tappedCell.pokemon)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}


