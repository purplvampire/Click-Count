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
        
        // Disbale button while tapelist is empty.
        if tapeList.count == 0 {
            sumBarButtonItem.isEnabled = false
            
        }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let controller = segue.destination as? SumTableViewController else {
            assertionFailure("no this VC")
            return
        }
        controller.tapeTimes = tapeList
        
    }


}
