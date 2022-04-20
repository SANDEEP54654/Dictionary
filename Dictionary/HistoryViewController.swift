//
//  HistoryViewController.swift
//  Dictionary
//
//  Created by Group2 on 26/03/22.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var wordObjects = [NSManagedObject]()
    
    let dataHelpper = DataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let font = UIFont(name: "Avenir Next", size: 16.0)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : font!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func refreshWords(forFavorite: Bool, _ viewAppeared: Bool = false) {
        
        if viewAppeared{
            self.segmentedControl.selectedSegmentIndex = 0
        }
        
        if let objects = dataHelpper.fetchData(for: "", isFavorite: forFavorite){
            
            self.wordObjects = objects
            self.tableView.reloadData()
        }
    }

    // MARK: - IBAction
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        
        self.refreshWords(forFavorite: sender.selectedSegmentIndex != 0)
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

//MARK:- TableView Delegate & DataSource

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell")!
        
        if let wordFeed = self.dataHelpper.parseWord(for: self.wordObjects[indexPath.row]){
            
            cell.textLabel?.text = wordFeed.word
        }
        
        return cell
    }
    
    
}
