//
//  ViewController.swift
//  Gesture
//
//  Created by 陳信彰 on 2024/6/14.
//

import UIKit

class TapeViewController: UIViewController {
    
    var countNumber: Int = 0
    var tapeTimes = [Date]()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get full screen size
        backgroundView.backgroundColor = .systemMint

    }

    @IBAction func tapeToCount(_ sender: Any) {
        
        countNumber += 1
        countLabel.text = String(countNumber)
        
        blinkanimation()    // Tape Animator
        
        let currentTime = Date()
        tapeTimes.append(currentTime)
//        print(tapeTimes)
        
    }
    
    private func blinkanimation() {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: []) {
            
            self.backgroundView.alpha = 0.2
            
        } completion: { _ in
            self.backgroundView.alpha = 1
        }

    }
    
    @IBAction func clearCount(_ sender: UIBarButtonItem) {
        
        self.countNumber = 0
        self.tapeTimes = []
        countLabel.text = String(countNumber)
    }
    
    
    @IBSegueAction func showTapeTimes(_ coder: NSCoder) -> CountTableViewController? {

        tapeTimes = tapeTimes.sorted(by: {
            
            $0.compare($1) == .orderedDescending
        })
        return CountTableViewController(coder: coder, tapeTimes: tapeTimes)
    }
    
    
}

