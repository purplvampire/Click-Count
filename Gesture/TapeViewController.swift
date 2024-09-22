//
//  ViewController.swift
//  Gesture
//
//  Created by 陳信彰 on 2024/6/14.
//

import UIKit
import AVFoundation // 手機音樂


class TapeViewController: UIViewController {
    
    var countNumber: Int = 0
    var tapeTimes = [Date]() {
        didSet {
            TapeDataManager.shared.saveTapeData(tapeTimes)
        }
    }
    var tapeData: [Date]? {
        TapeDataManager.shared.loadTapeData()
    }
    
    var themeColor: String {
        UserDefaultsManager.shared.getThemeColor()
    }
    var enableTapVibration: Bool {
        UserDefaultsManager.shared.getWaveEnable()
    }
    var enableTapSound: Bool {
        UserDefaultsManager.shared.getSoundEnable()
    }
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get full screen size
//        backgroundView.backgroundColor = .systemMint
        updateUI(themeColor: themeColor)
        
        // load data
        if tapeData != nil {
            checkBeforeLoadTapeData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI(themeColor: themeColor)
    }
    
    func updateUI(themeColor: String) {
        
        setBackgroundColor(themeColor)
        
    }
    
    func loadTapeData() {
        
        guard let tapeTimes = TapeDataManager.shared.loadTapeData() else { return }
        self.tapeTimes = tapeTimes
    }
    
    func checkBeforeLoadTapeData() {
        
        let message = NSLocalizedString("TapeVC.continueMessage", comment: "是否繼承前次紀錄")
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.loadTapeData()
            self.countNumber = self.tapeTimes.count
            self.countLabel.text = "\(self.countNumber)"
            print(self.tapeTimes.count)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func setBackgroundColor(_ color: String) {

        switch color {
        case "mint":
            self.backgroundView.backgroundColor = .systemMint
        case "orange":
            self.backgroundView.backgroundColor = .orange
        case "gray":
            self.backgroundView.backgroundColor = .gray
        case "cyan":
            self.backgroundView.backgroundColor = .systemCyan
        case "purple":
            self.backgroundView.backgroundColor = .purple
        default:
            self.backgroundView.backgroundColor = .black
        }

    }
    

    @IBAction func tapeToCount(_ sender: Any) {
        
        // 手機震動
        tapWave(enableTapVibration)
        
        // 音效
        tapSound(enableTapSound)
        
        // 計算
        countNumber += 1
        countLabel.text = String(countNumber)
        
        // 動畫
        blinkanimation()    // Tape Animator
        
        // 點擊時間紀錄
        let currentTime = Date()
        tapeTimes.append(currentTime)
//        print(tapeTimes)
        
    }
    
    func tapWave(_ isOn: Bool) {
        
        if isOn {
            // 手機震動
            if #available(iOS 17.5, *) {
                let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy, view: backgroundView)
                impactFeedbackGenerator.impactOccurred()
            } else {
                // Fallback on earlier versions
                let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedbackGenerator.impactOccurred()
            }
        } else {
            return
        }
    }
    
    func tapSound(_ isOn: Bool) {
        
        if isOn {

            guard let path = Bundle.main.path(forResource: "mobile_phone_C", ofType: "mp3") else {
                assertionFailure("找不到音頻文件")
                return
            }
            let url = URL(fileURLWithPath: path)
            
            do {
                // 初始化音頻播放器
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                assertionFailure("無法播放音頻文件")
            }
        } else {
            return
        }

    }
    
    private func blinkanimation() {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: []) {
            
            self.backgroundView.alpha = 0.2
            
        } completion: { _ in
            self.backgroundView.alpha = 1
        }

    }
    
    @IBAction func clear(_ sender: Any) {
        
        let message = NSLocalizedString("TapeVC.clearMessage", comment: "清除計算")
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { action in
            self.clearCounting()
        }
        alertVC.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true)
    }
    
    func clearCounting() {

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

