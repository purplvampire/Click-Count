//
//  SumTableViewController.swift
//  Gesture
//
//  Created by 陳信彰 on 2024/6/16.
//

import UIKit
import StoreKit     // App評分
import MessageUI    // 寄信

class SumTableViewController: UITableViewController {
    
    var periodHours = 1
    var periodTapes = 0
    var tapeTimes = [Date]()
    var hourlyCounts = [Int: Int]()
    var sortedHourCounts: [(hour: Int, count: Int)] = []
    
    let calendar = Calendar.current
    let hourInterval = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let startDate = tapeTimes.first,
              let endDate = tapeTimes.last else {
            
            assertionFailure("No date interval")
            return
        }
        
        var currentDate = startDate
        
        while currentDate <= endDate {
            
            if let nextDate = Calendar.current.date(byAdding: .hour, value: hourInterval, to: currentDate) {
                
                currentDate = nextDate
                
            } else {
                break
            }
            
        }

        sortedHourCounts = calculateTapeCount(tapeTimes: tapeTimes)
        periodHours = sortedHourCounts.count
//        print(sortedHourCounts)
        
    }
    
    func calculateTapeCount(tapeTimes: [Date]) -> [(hour: Int, count: Int)] {

        for timestamp in tapeTimes {
            let hour = calendar.component(.hour, from: timestamp)
            hourlyCounts[hour, default: 0] += 1
        }
        
        for (hour, count) in hourlyCounts.sorted(by: { $0.key < $1.key }) {
//            print("小時 \(hour): \(count)次")
        }
        
        let sortedHourCounts = hourlyCounts.map { ($0.key, $0.value) }.sorted { $0.0 > $1.0 }
        
        return sortedHourCounts
    }
    
    
    @IBAction func rating(_ sender: Any) {
        
        callAlertVC()
//        requestAppReview()
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
            let message = "Can't send email to me, please check your mail setting!"
            let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertVC.addAction(okAction)
            present(alertVC, animated: true)
        }
    }
    
    // 呼叫告警視窗
    func callAlertVC() {
        let listTitle = NSLocalizedString("SumTableVC.choiceTitle", comment: "More")
        let alertVC = UIAlertController(title: listTitle, message: nil, preferredStyle: .actionSheet)
        /*
        let buttonNames = ["Rating", "About me", "Send Request"]
        for buttonName in buttonNames {
            let action = UIAlertAction(title: buttonName, style: .default) { action in
                print(action.title)
            }
            alertVC.addAction(action)
        }
         */
        let ratingTitle = NSLocalizedString("SumTableVC.ratingTitle", comment: "Rating")
        let ratingAction = UIAlertAction(title: "Rating", style: .default) { [weak self] action in
            guard let self else { return }
            
            self.requestAppReview()
        }
        alertVC.addAction(ratingAction)
        
        let feedbackTitle = NSLocalizedString("SumTableVC.feedbackTitle", comment: "Feedback")
        let sendMailAction = UIAlertAction(title: feedbackTitle, style: .default) { [weak self] action in
            guard let self else { return }
            
            self.openMailComposer()
        }
        alertVC.addAction(sendMailAction)
        
        let infoTitle = NSLocalizedString("SumTableVC.infoTitle", comment: "About Me")
        let aboutMeAction = UIAlertAction(title: infoTitle, style: .default) { [weak self] action in
            guard let self else { return }
            self.openWebSite("https://twitter.com/purplvampire")
        }
        alertVC.addAction(aboutMeAction)
        /*
        let privacyAction = UIAlertAction(title: "Privacy Policy", style: .default) { [weak self] action in
            guard let self else { return }
            self.openWebSite("https://twitter.com/purplvampire")
        }
        alertVC.addAction(aboutMeAction)
        */
        let cancelString = NSLocalizedString("SumTableVC.cancelString", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return periodHours
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SumTableViewCell.self)", for: indexPath) as! SumTableViewCell

        // Configure the cell...
        let row = indexPath.row
        let hourTitle = NSLocalizedString("SumTableVC.hourTitle", comment: "最近n小時的點擊次數為")
        let hour = row + 1
        
        cell.periodLabel.text = String.localizedStringWithFormat(hourTitle, hour)
        
        let countStr = NSLocalizedString("SumTableVC.count", comment: "n次")
        let countNum = sortedHourCounts[row].count
        
        cell.tapeCountLabel.text = String.localizedStringWithFormat(countStr, countNum)

        return cell
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

extension SumTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        
        controller.dismiss(animated: true)
    }
}
