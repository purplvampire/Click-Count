//
//  SumTableViewController.swift
//  Gesture
//
//  Created by 陳信彰 on 2024/6/16.
//

import UIKit
import StoreKit     // App評分

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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        
        for timestamp in tapeTimes {
            let hour = calendar.component(.hour, from: timestamp)
            hourlyCounts[hour, default: 0] += 1
        }
        
        for (hour, count) in hourlyCounts.sorted(by: { $0.key < $1.key }) {
            print("小時 \(hour): \(count)次")
        }
        
        sortedHourCounts = hourlyCounts.map { ($0.key, $0.value) }.sorted { $0.0 > $1.0 }
        periodHours = sortedHourCounts.count
        print(sortedHourCounts)
        
    }
    
    func calculateTapeCount(tapeTimes: [Date]?) -> [(hour: Int, count: Int)]? {
        guard let tapeTimes else {
            assertionFailure("no value")
            return nil
        }
        for timestamp in tapeTimes {
            let hour = calendar.component(.hour, from: timestamp)
            hourlyCounts[hour, default: 0] += 1
        }
        
        for (hour, count) in hourlyCounts.sorted(by: { $0.key < $1.key }) {
            print("小時 \(hour): \(count)次")
        }
        
        let sortedHourCounts = hourlyCounts.map { ($0.key, $0.value) }.sorted { $0.0 > $1.0 }
        
        return sortedHourCounts
    }
    
    
    @IBAction func rating(_ sender: Any) {
        
        requestAppReview()
        
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
