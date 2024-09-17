//
//  SetupTableViewController.swift
//  Click&Count
//
//  Created by 陳信彰 on 2024/7/17.
//

import UIKit
import StoreKit     // App評分
import MessageUI    // mail

protocol SetupTableVCDelegate {
    //
}

class SetupTableViewController: UITableViewController {
    
    @IBOutlet weak var mintButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var grayButton: UIButton!
    @IBOutlet weak var cyanButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    @IBOutlet weak var waveSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
    }
    
    func updateUI() {
        
        waveSwitch.isOn = UserDefaultsManager.shared.getWaveEnable()
        soundSwitch.isOn = UserDefaultsManager.shared.getSoundEnable()
        
    }
    
    
    @IBAction func choiceThemeColor(_ sender: UIButton) {
        
        switch sender {
        case orangeButton:
//            print("orange")
            UserDefaultsManager.shared.setThemeColor("orange")
            callAlertVC("Orange")
        case mintButton:
//            print("mint")
            UserDefaultsManager.shared.setThemeColor("mint")
            callAlertVC("Mint")
        case cyanButton:
//            print("cyan")
            UserDefaultsManager.shared.setThemeColor("cyan")
            callAlertVC("Cyan")
        case grayButton:
//            print("gray")
            UserDefaultsManager.shared.setThemeColor("gray")
            callAlertVC("Gray")
        case purpleButton:
//            print("purple")
            UserDefaultsManager.shared.setThemeColor("purple")
            callAlertVC("Purple")
        default:
            break
        }
        
    }
    
    func callAlertVC(_ color: String) {
        let alertVC = UIAlertController(title: color, message: "Setup Color Success", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true)
    }
    
    
    @IBAction func onWave(_ sender: UISwitch) {
        if sender.isOn {
            print("Wave")
            UserDefaultsManager.shared.setWaveEnable(true)
        } else {
            UserDefaultsManager.shared.setWaveEnable(false)
        }
    }
    
    @IBAction func onSound(_ sender: UISwitch) {
        if sender.isOn {
            print("Sound")
            UserDefaultsManager.shared.setSoundEnable(true)
        } else {
            UserDefaultsManager.shared.setSoundEnable(false)
        }
    }
    
    
    @IBAction func linkApp1(_ sender: Any) {
        let urlString = "https://apps.apple.com/tw/app/id6468792209"
        openWebSite(urlString)
    }
    
    @IBAction func linkApp2(_ sender: Any) {
        let urlString = "https://apps.apple.com/tw/app/id6465072522"
        openWebSite(urlString)
    }
    
    @IBAction func linkApp3(_ sender: Any) {
        let urlString = "https://apps.apple.com/tw/app/id6452241138"
        openWebSite(urlString)
    }
    
    
    // 呼叫評分視圖
    func requestAppReview() {
        if #available(iOS 14.0, *) {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                // 呼叫評分提示
                SKStoreReviewController.requestReview(in: windowScene)
            }
        } else {
            return
        }
    }
    
    func openWebSite(_ url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
    func openMailComposer() {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["findgood168@gmail.com"])
            mailComposer.setSubject("Click&Count")
            let mailBody = NSLocalizedString("SumTableVC.mailBody", comment: "I have a feedback!")
            mailComposer.setMessageBody(mailBody, isHTML: false)
            
            present(mailComposer, animated: true)
            
        } else {
            
            let message = NSLocalizedString("SumTableVC.mailMsg", comment: "Can't send email to me, please check your mail setting!")
            let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertVC.addAction(okAction)
            
            
            present(alertVC, animated: true)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
        switch indexPath {
        case [1,0]:
            print("About me")
            let socialUrl = "https://twitter.com/purplvampire"
            self.openWebSite(socialUrl)
        case [1,1]:
            print("Privacy Policy")
            let privacyUrl = "https://www.privacypolicies.com/live/0890127a-4c4a-4931-ba49-fa660c5ae3ca"
            self.openWebSite(privacyUrl)
        case [1,2]:
            print("Rating")
            self.requestAppReview()
        case [1,3]:
            print("Email me")
            self.openMailComposer()
        case [1,4]:
            print("License Agreement")
            self.performSegue(withIdentifier: "showLicense", sender: nil)
        default:
            break
        }
        // 取消選擇
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetupTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        
        controller.dismiss(animated: true)
    }
}
