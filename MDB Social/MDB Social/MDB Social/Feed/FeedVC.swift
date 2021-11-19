
import UIKit
import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FeedVC: UIViewController {
    
    static var shared = FeedVC()
    
    var events: [SOCEvent] = []
    
    private let signOutButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Sign Out", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    private let socialCreationButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Create Event", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        
        return btn
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(eventCell.self, forCellWithReuseIdentifier: eventCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        FIRDatabaseRequest.shared.getEvents(completion: { eventsCollection in
            self.events = eventsCollection
            self.collectionView.reloadData()
        })
        
        //signOutButton
        print(events)
        
        
        //Collection View
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width/4, height: view.bounds.width/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0))
        
        view.addSubview((collectionView))
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(signOutButton)
        NSLayoutConstraint.activate([
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(socialCreationButton)
        
        NSLayoutConstraint.activate([
            socialCreationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            socialCreationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        
        socialCreationButton.addTarget(self, action: #selector(didTapCreation(_:)), for: .touchUpInside)
        
    }
    
    @objc func didTapCreation(_ sender: UIButton) {
        let vc = SocialCreationVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        print("tapped")
        SOCAuthManager.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
}

extension FeedVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell.reuseIdentifier, for: indexPath) as! eventCell
        let currentEvent = events[indexPath.item]
        FIRDatabaseRequest.shared.getUser(uid: currentEvent.creator, completion: {user in cell.creator = "Creator: " + user.fullname})
        cell.url = URL(string: events[indexPath.item].photoURL)
        cell.name = "Event: " + currentEvent.name  +  "\n RSVP: " +  String(currentEvent.rsvpUsers.count)
        return cell
    }
    
}

extension FeedVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at: indexPath) as! eventCell
        let vc = IndividualVC(givenEvent: events[indexPath.item])
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated:false, completion: nil)
    }
}
