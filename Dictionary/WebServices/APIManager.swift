//
//  APIHandler.swift
//  Dictionary
//
//  Created by Group2 on 26/03/22.
//

import Foundation
import CoreData

class APIManager {
    
    let baseURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    
    static let shared = APIManager()
    
    func fetchMeaning(for word: String, _ completion: @escaping(WordFeed) -> Void)  {
        
        let dataHelper = DataHandler()
        
        if let managedObjects = dataHelper.fetchData(for: word.lowercased()){
            
            if let jsonData = managedObjects.first?.value(forKey: "wordData") as? NSData{
                if let json  = try? JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? [Any] {
                    completion( dataHelper.parseWord(from: json, jsonData as Data))
                    
                    return
                }
            }
    
        }
        
        let url = URL(string: self.baseURL + word)!
        
        print(url)
        
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let jsonData = data {
                
                if let json  = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] {
                    completion( dataHelper.parseWord(from: json, jsonData))
                }
                else{
                    completion(WordFeed(with: [String : Any]()))
                }
                
//
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
}
