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
    
    var periodTapes = 0
    var tapeTimes = [Date]()
    var hourlyCounts = [Int: Int]()
//    var sortedHourCounts: [(hour: Int, count: Int)] = []
    var sortedHourCountsByDate: [String: [(Int,Int)]] = [:]
    var sortedDates: [String] = []
    
    let calendar = Calendar.current
    let hourInterval = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        sortedHourCountsByDate = calculateTapeCountByDate(tapeTimes: tapeTimes)
        
        // 取得日期列表(Section名稱)
        sortedDates = sortedHourCountsByDate.keys.sorted(by: >) // 按照日期降序

        
        tableView.reloadData()
        
    }
    
    // 請改寫這段函式，將hour值改為24小時制中的小時
    func calculateTapeCountByDate(tapeTimes: [Date]) -> [String: [(hour: Int, count: Int)]] {
        
        var dateHourlyCounts: [String: [Int:Int]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for timestamp in tapeTimes {
            let date = dateFormatter.string(from: timestamp)        // 取得日期
            let hour = calendar.component(.hour, from: timestamp)   // 取得小時區間
            
            // 檢查是否有該日期的紀錄，若無則初始化一個[Int: Int]字典
            if dateHourlyCounts[date] == nil {
                dateHourlyCounts[date] = [Int:Int]()
            }
            // 在該日期的字典中，檢查小時是否存在，若無則初始化為0，然後累加
            dateHourlyCounts[date]![hour, default: 0] += 1
        }
        
        // 將結果轉換成[String: [(hour: Int, count: Int)]] = [:]
        var result: [String: [(hour: Int, count: Int)]] = [:]
        
        for (date, dateHourlyCount) in dateHourlyCounts {
            
            result[date] = dateHourlyCount.map { ($0.key, $0.value) }.sorted(by: { $0.0 > $1.0 })   // 倒序重組
        }
        return result
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sortedHourCountsByDate.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = sortedDates[section]

        return sortedHourCountsByDate[date]?.count ?? 0
    }

    // Section Header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedDates[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SumTableViewCell.self)", for: indexPath) as! SumTableViewCell

        // Configure the cell...
        let date = sortedDates[indexPath.section]   // 取得對應的日期
        let row = indexPath.row
        
        
        
        
        if let hourlyCounts = sortedHourCountsByDate[date] {
            
            let hourTitle = NSLocalizedString("SumTableVC.hourTitle", comment: "n點鐘的點擊次數為")
            let hour = hourlyCounts[row].0
            
            cell.periodLabel.text = String.localizedStringWithFormat(hourTitle, hour)
            
            let countStr = NSLocalizedString("SumTableVC.count", comment: "n次")
            let countNum = hourlyCounts[row].1
            
            cell.tapeCountLabel.text = String.localizedStringWithFormat(countStr, countNum)
        }
            

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
