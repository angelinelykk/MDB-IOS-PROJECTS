
import UIKit

class FeedVC: UIViewController {
    
    var events: [SOCEvent] = []
    
    private let signOutButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setTitle("Sign Out", for: .normal)
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
        
        
        view.addSubview(signOutButton)
        signOutButton.center = view.center
        //NSLayoutConstraint.activate([
            //signOutButton.center = view.center
            //signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //])
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        
    }
    
    
    @objc func didTapSignOut(_ sender: UIButton) {
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
