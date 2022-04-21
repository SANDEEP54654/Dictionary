//
//  RandomViewController.swift
//  Dictionary
//
//  Created by Group2 on 20/04/22.
//

import UIKit

class RandomViewController: UIViewController {

    @IBOutlet weak var lblRandomWord: UILabel!
    
    var randomWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblRandomWord.text = randomWord
    }
    
    //MARK:- IBActions
    
    @IBAction func hideViewController(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewDetails(_ sender: Any){
        
        let detailsVC = NavigationHelper.viewController(with: .detail) as! DetailViewController
        
        detailsVC.wordText = self.randomWord
        
        self.present(detailsVC, animated: true, completion: nil)
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
