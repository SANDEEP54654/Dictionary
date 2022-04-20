//
//  DataSource.swift
//  Dictionary
//
//  Created by Group2 on 28/03/22.
//

import Foundation
import CoreData

class DataHandler {
    
    //MARK:- Variables
    
    var managedObjectContext: NSManagedObjectContext?
    
    lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "Dictionary")
    }()
    
    init() {
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            }
        }
    }
    
    //MARK: Functions
    
    func parseWord(from info: [Any], _ data: Data) -> WordFeed{
        
        if let details = info[0] as? [String : Any]{
            
            let word = WordFeed(with: details)
            
            if word.meanings.count > 0{
                self.saveToCoreData(for: word.word, data)
            }
            
            return word
            
        }
        
        return WordFeed(with: [String : Any]())
    }
    
    func parseWord(for managedObject: NSManagedObject?) -> WordFeed?{
        
        
        if let jsonData = managedObject?.value(forKey: "wordData") as? NSData{
            if let json  = try? JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? [Any] {
                
                return self.parseWord(from: json, jsonData as Data)
            }
        }
        
        return nil
    }
    
}

//MARK: Core Data

extension DataHandler{
    
    // Save
    
    func saveToCoreData(for wordTitle: String, _ data: Data){
        
        self.managedObjectContext = persistentContainer.viewContext
        
        guard let managedObjectContext = managedObjectContext else {
            fatalError("No Managed Object Context Available")
        }
        
        let alreadyExists = (self.fetchData(for: wordTitle)?.first) != nil
        
        if !alreadyExists {
            
            // Create Word Obj
            let word = Word(context: managedObjectContext)
     
            // Add attributes
            word.word = wordTitle
            word.wordData = data
            word.isFavorite = false
            
            do {
                // Save Word to Persistent Store
                try managedObjectContext.save()
                
            } catch {
                print("Unable to Save Book, \(error)")
            }
        }
    }
    
    // Fetch
    
    func fetchData(for wordTitle: String, isFavorite: Bool = false) -> [NSManagedObject]?{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        if wordTitle != ""{
            request.predicate = NSPredicate(format: "word = %@", wordTitle)
        }
        else if isFavorite{
           request.predicate = NSPredicate(format: "isFavorite = %d", true)
        }
        
        //
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
          
            return result as? [NSManagedObject]
            
            
        } catch {
            
            print("Failed")
        }
        
        return nil
    }
    
    func updateWord( value: String, _ isFavorite : Bool) {
        
        if let managedObjects = self.fetchData(for: value, isFavorite: isFavorite){
            
            (managedObjects.first as! Word).isFavorite = !isFavorite
            
            self.managedObjectContext = persistentContainer.viewContext
            
            guard let managedObjectContext = self.managedObjectContext else {
                fatalError("No Managed Object Context Available")
            }
            
            do {
                // Save Word to Persistent Store
                try managedObjectContext.save()
                
            } catch {
                print("Unable to Save Book, \(error)")
            }
        }
    }
    
}
