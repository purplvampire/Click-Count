//
//  CountTableViewController.swift
//  Gesture
//
//  Created by 陳信彰 on 2024/6/16.
//

import UIKit

class CountTableViewController: UITableViewController {
    
    
    @IBOutlet weak var sumBarButtonItem: UIBarButtonItem!
    
    let tapeList: [Date]
    
    required init?(coder: NSCoder, tapeTimes: [Date]) {
        self.tapeList = tapeTimes
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func toSumTableVC(_ sender: UIBarButtonItem) {
        
        // 指定segue到下一個畫面，並將物件的Tag傳遞給prepare()
        performSegue(withIdentifier: "ToSumVCSegue", sender: sender)
        
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tapeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CountTableViewCell.self)", for: indexPath) as! CountTableViewCell

        // Configure the cell...
        let row = indexPath.row
        let tape = tapeList[row]
        
        cell.numberLabel.text = String(row + 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        
        cell.timeLabel.text = dateFormatter.string(from: tape)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let controller = segue.destination as? SumTableViewController else {
            assertionFailure("no this VC")
            return
        }
        controller.tapeTimes = tapeList
        
    }


}
