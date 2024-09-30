//
//  LicenseTableViewController.swift
//  Click&Count
//
//  Created by 陳信彰 on 2024/9/17.
//

import UIKit


class LicenseTableViewController: UITableViewController {
    
    @IBOutlet weak var licenseNavigationItem: UINavigationItem!
    
    let licenseText: LicenseData = LicenseData(title: "1", content: nil)
    let licenseData: [LicenseData] = [
        LicenseData(title: "小森平的免費下載音效",
                    content: """
                    素材制造者･版權：小森 平（日本/福岡在住)
                    使用軟件：Audacity　GIMP
                    website: https://taira-komori.jpn.org/freesoundtw.html
                    e-mail : komoritaira@gmail.com
                    """),
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateUI()
    }
    
    func updateUI() {
        licenseNavigationItem.title = NSLocalizedString("LicenseTableVC.licenseTitle", comment: "License")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return licenseData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(LicenseTableViewCell.self)", for: indexPath) as! LicenseTableViewCell

        // Configure the cell...
        let license = licenseData[indexPath.row]
        cell.titleLabel.text = license.title
        cell.contentTextView.text = license.content

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
