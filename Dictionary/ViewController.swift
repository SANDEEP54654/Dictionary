//
//  ViewController.swift
//  Dictionary
//
//  Created by Group2 on 21/03/22.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var detailsVC : DetailViewController!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tabBar.delegate  = self
        self.searchBar.delegate = self
        
        self.activityIndicator.isHidden = true
        
        self.addDetailView()
    }
    
    //MARK:- Add Custom Views
    
    private func addDetailView(){
        
        if let detailVC = NavigationHelper.viewController(with: .detail) as? DetailViewController{
            
            self.detailsVC = detailVC
            
            self.contentView.addSubview(detailVC.view)
            
            detailVC.view.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
            
            self.addChild(detailVC)
            
        }
        
    }
    
    //MARK:- Animations
    
    fileprivate func animateTop(withConstant: CGFloat){
     
        if withConstant != 8{
            UIView.animate(withDuration: 0.5) {
                self.top.constant = withConstant
                self.view.layoutIfNeeded()
            } completion: { success in
            }
        }else{
            self.top.constant = withConstant
            self.view.layoutIfNeeded()
        }
        
        

    }
}

//MARK: - Tab Bar Delegate

extension ViewController: UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 0{
            
            self.contentView.bringSubviewToFront(self.detailsVC.view)
            
            self.animateTop(withConstant: 51.0)
            
        }else{
            self.contentView.sendSubviewToBack(self.detailsVC.view)
            
            self.animateTop(withConstant: 8)
            
            for child in self.children{
                
                if child is HistoryViewController{
                    
                    (child as! HistoryViewController).refreshWords(forFavorite: false, true)
                }
            }
            
        }
        
    }
}

//MARK: - Search Bar Delegate

extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.detailsVC.btnBookmark.isEnabled = false
        
        APIManager.shared.fetchMeaning(for: searchBar.text ?? "") { (word,isFavorite)  in
            
            print("Phonetic: \(word.phonetic) Word: \(word.word)")
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.detailsVC.displayData(word, isFavorite)
            }
        }
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
