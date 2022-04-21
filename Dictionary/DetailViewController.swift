//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Group2 on 26/03/22.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet weak var lblWord: UILabel!
    
    @IBOutlet weak var lblPhonetic: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAudio: UIButton!
    
    @IBOutlet weak var btnBookmark: UIButton!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var lblMessage: UILabel!
    var word = WordFeed(with: [String : Any]())
    
    var player:AVPlayer?
    
    var wordText = ""
    
    var playerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        if wordText != "" {
            APIManager.shared.fetchMeaning(for: wordText) { (word,isFavorite)  in
                DispatchQueue.main.async {
                    self.displayData(word, isFavorite)
                }
            }
        }
    }
    
    func displayData(_ withWord : WordFeed, _ isFavorite: Bool){
        
        self.word = withWord
        
        self.lblWord.text = withWord.word
        
        self.messageView.isHidden = withWord.word != ""
        
        if withWord.word == ""{
            //Change message for empty results
            self.lblMessage.text = Message.notfound.rawValue
            //
        }
        
        self.lblPhonetic.text = withWord.phonetic

        self.btnAudio.isEnabled = (self.word.audioUrl != "")
        
        let image = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        self.btnBookmark.setImage(image, for: .normal)
        
        self.btnBookmark.isEnabled = true
        
        self.tableView.reloadData()
    }
    
    // MARK: - IBAction
    
    @IBAction func audioPronunciation(_ sender: UIButton) {
        
        if word.audioUrl != ""{
         
            let url = URL(string: word.audioUrl)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            
            player?.play()
        }
    }
    
    @IBAction func saveWord(_ sender: UIButton) {

       var isBookmarked =  ViewManager.setBookmarkImage(for: sender)
        
        if word.word != "" {
            DataHandler().updateWord(value: word.word, !isBookmarked)
        }

        print(isBookmarked)
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

//MARK:- Tableview Delegate & Datasource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.word.meanings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.word.meanings[section].definitions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let definition = self.word.meanings[indexPath.section].definitions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionCell")
        
        //Labels
        let lblDefinition = cell?.viewWithTag(10) as! UILabel
        let lblExample    = cell?.viewWithTag(20) as! UILabel
        //
        
        lblDefinition.text = "\(indexPath.row+1). " + definition.wordDefinition
        
        if definition.example != "" {
            lblExample.text = "ex: " + definition.example
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "Section")

        let lblDefinitionType = headerView?.viewWithTag(10) as? UILabel
        
        lblDefinitionType?.text = "Definitions: (\(self.word.meanings[section].partOfSpeech))"
        
        return headerView
    }
    
}
