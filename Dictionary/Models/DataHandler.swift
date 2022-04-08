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
            
            do {
                // Save Word to Persistent Store
                try managedObjectContext.save()
                
            } catch {
                print("Unable to Save Book, \(error)")
            }
        }
        
    }
    
    // Fetch
    
    func fetchData(for wordTitle: String) -> [NSManagedObject]?{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        if wordTitle != ""{
            request.predicate = NSPredicate(format: "word = %@", wordTitle)
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
}
