//
//  DataSource.swift
//  Dictionary
//
//  Created by Group2 on 28/03/22.
//

import Foundation

class DataHandler {
    
    func parseWord(from info: [Any], _ data: Data) -> WordFeed{
        
        if let details = info[0] as? [String : Any]{
        
            let word = WordFeed(with: details)
            
            if word.meanings.count > 0{
                self.saveToCoreData(data)
            }
            
            return word
            
        }
        
        return WordFeed(with: [String : Any]())
    }
    
    // CoreData
    
    func saveToCoreData(_ data: Data){
        
        
    }
}
