//
//  StatsVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 11: Going to StatsVC
    // Read the instructions in MainVC.swift
    
    var mainGame: MainVC?
    
    init(game: MainVC) {
        
        super.init(nibName: nil, bundle: nil)
        mainGame = game
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 12: StatsVC UI
    // Action Items:
    // - Initialize the UI components, add subviews and constraints
    
    // MARK: >> Your Code Here <<
    
    private let longest: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Longest Streak"
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let longestNumber: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = String(MainVC.longestStreak)
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let results: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        if MainVC.answers.count >= 3 {
            label.text = "Past 3 Results \n\n (Most recent to least) \n\n" + MainVC.answers.reversed()[0] + ", " + MainVC.answers.reversed()[1] + ", " + MainVC.answers.reversed()[2]
        }
        if MainVC.answers.count == 2 {
            label.text = "Past 3 Results \n\n (Most recent to least) \n\n" + MainVC.answers.reversed()[0] + ", " + MainVC.answers.reversed()[1]
        }
        if MainVC.answers.count == 1 {
            label.text = "Past 3 Results \n\n (Most recent to least) \n\n" + MainVC.answers.reversed()[0]
        }
        
        if MainVC.answers.count == 0 {
            label.text = "Past 3 Results \n\n (Most recent to least) \n\n"
        }
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(longest)
        view.addSubview(longestNumber)
        view.addSubview(results)
        
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            longest.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            longest.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            longest.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            longestNumber.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            longestNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            longestNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            results.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            results.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            results.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
    }
    
}
