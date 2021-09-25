//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    
    static var score = 0
    
    var stats = false
    
    static var longestStreak = 0
    
    static var currentStreak = 0
    
    static var paused = false
    
    static var answer: String?
    
    static var pressedButton: Bool?
    
    static var pressed = 0
    
    static var correctButtonTag = 0
    
    static var timer: Timer?
    
    static var count = 0
    
    static var answers: [String] = []
    
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    
    let imageView: UIImageView = {
        let view = UIImageView()

    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            
            // MARK: >> Your Code Here <<
            button.backgroundColor = .systemMint
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    
    private let statsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Stats", for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        
        // MARK: STEP 1: UIButton Customization
        // Action Items:
        // - Customize `UIButton` through modifying its property
        //
        // Hints: Wondering what customizations are available?
        // Type out `button.` and Swift will show you a bunch of options, then
        // keep typing to narrow it down (try 'background').
        // You can also go to https://developer.apple.com/documentation/uikit/uibutton#topics
        // where you will find all the available APIs.
        
        // MARK: >> Your Code Here <<
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Score: 0"
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pauseResumeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Pause", for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        
        // MARK: STEP 1: UIButton Customization
        // Action Items:
        // - Customize `UIButton` through modifying its property
        //
        // Hints: Wondering what customizations are available?
        // Type out `button.` and Swift will show you a bunch of options, then
        // keep typing to narrow it down (try 'background').
        // You can also go to https://developer.apple.com/documentation/uikit/uibutton#topics
        // where you will find all the available APIs.
        
        // MARK: >> Your Code Here <<
        button.tintColor = .white
        button.backgroundColor = .systemGray
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
        MainVC.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        // MARK: >> Your Code Here <<
        view.addSubview(imageView)
        view.addSubview(buttons[0])
        view.addSubview(buttons[1])
        view.addSubview(buttons[2])
        view.addSubview(buttons[3])
        view.addSubview(statsButton)
        view.addSubview(pauseResumeButton)
        view.addSubview(scoreLabel)
        
        
        getNextQuestion()
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
            
            
        ])
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -350),
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            buttons[0].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 450),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            buttons[1].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            buttons[2].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 550),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            buttons[3].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 600),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])

        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            statsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 650),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            statsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        NSLayoutConstraint.activate([
            // You can use the view.topAnchor. But it's different, why?
            // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
            pauseResumeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 700),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            pauseResumeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            pauseResumeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            
        ])
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        buttons[0].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        // MARK: >> Your Code Here <<
        
        buttons[1].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        // MARK: STEP 10: Stats Button
        // See instructions above.
        buttons[2].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        // MARK: >> Your Code Here <<
        buttons[3].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        
        statsButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        pauseResumeButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // Action Items:
        // - Reinstantiate timer when view appears
        
        // MARK: >> Your Code Here <<
        
        if stats == true {
            stats = false
            MainVC.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        
        
        let question = QuestionProvider.shared.nextQuestion()
        
        let image = question?.image
        let newAnswer = question?.answer
        let choices = question?.choices
    
        imageView.image = image
        
        buttons[0].setTitle(choices?[0], for: .normal)
        buttons[1].setTitle(choices?[1], for: .normal)
        buttons[2].setTitle(choices?[2], for: .normal)
        buttons[3].setTitle(choices?[3], for: .normal)
        
        MainVC.answer = newAnswer
        
        
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - The timer will fire every one second.
    // - You can use `sender.tag` to identify which button is pressed.
    @objc func timerCallback() {
        scoreLabel.text = "Score: " + String(MainVC.score)
        for button in buttons {
            if (button.titleLabel!.text == MainVC.answer) {
                MainVC.correctButtonTag = button.tag
            }
        }
        if MainVC.count >= 5 {
            for button in buttons {
                if (button.titleLabel!.text) == MainVC.answer {
                    button.backgroundColor = .systemGreen
                    MainVC.correctButtonTag = button.tag
                }
            }
            
            
            buttons[MainVC.correctButtonTag].backgroundColor = .systemGreen
            if MainVC.count == 7 {
                MainVC.currentStreak = 0
                MainVC.count = 0
                buttons[MainVC.correctButtonTag].backgroundColor = .systemMint
                MainVC.answers.append("Wrong")
                getNextQuestion()
            }
        }
        
        if (MainVC.pressedButton == true) {
            if MainVC.count == 2 {
                buttons[MainVC.pressed].backgroundColor = .systemMint
                buttons[MainVC.correctButtonTag].backgroundColor = .systemMint
                MainVC.count = 0
                MainVC.pressedButton = false
                getNextQuestion()
            }
        }
        MainVC.count += 1
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        MainVC.pressedButton = true
        MainVC.pressed = sender.tag
        MainVC.count = 0
        
        if buttons[sender.tag].titleLabel!.text == MainVC.answer {
            MainVC.score += 1
            MainVC.currentStreak += 1
            MainVC.answers.append("Correct")
            if MainVC.currentStreak > MainVC.longestStreak {
                MainVC.longestStreak = MainVC.currentStreak
            }
            buttons[MainVC.pressed].backgroundColor = .systemGreen
        } else {
            buttons[MainVC.pressed].backgroundColor = .systemRed
            MainVC.answers.append("Wrong")
            MainVC.currentStreak = 0
            for button in buttons {
                if button.titleLabel!.text == MainVC.answer {
                    button.backgroundColor = .systemGreen
                    MainVC.correctButtonTag = button.tag
                }
            }
        }
        /**if buttons[MainVC.pressed].tag == MainVC.correctButtonTag {
            MainVC.score += 1
            MainVC.currentStreak += 1
            MainVC.answers.append("Correct")
            if MainVC.currentStreak > MainVC.longestStreak {
                MainVC.longestStreak = MainVC.currentStreak
            }
            buttons[MainVC.pressed].backgroundColor = .systemGreen
        } else {
            MainVC.answers.append("Wrong")
            buttons[MainVC.pressed].backgroundColor = .systemRed
            buttons[MainVC.correctButtonTag].backgroundColor = .systemGreen
            MainVC.currentStreak = 0
        }*/
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        MainVC.paused = true
        stats = true
        MainVC.timer?.invalidate()
        MainVC.timer = nil
        let vc = StatsVC(game: self)
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapPause(_ sender: UIButton) {
        
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        if MainVC.paused == false {
            MainVC.paused = true
            MainVC.timer?.invalidate()
            pauseResumeButton.setTitle("Resume", for: .normal)
        } else {
            MainVC.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            pauseResumeButton.setTitle("Pause", for: .normal)
            MainVC.score = 0
            MainVC.paused = false
        }
    }
    

}
