//
//  Word.swift
//  Dictionary
//
//  Created by Group2 on 28/03/22.
//

import Foundation

class WordFeed {

    var word        = ""
    var phonetic    = ""
    var meanings    = [Meaning]()
    var audioUrl    = ""
    
    init(with info: [String : Any]) {
     
        self.word = info["word"] as? String ?? ""
        self.phonetic = info["phonetic"] as? String ?? ""
        
        if let meaningsData = info["meanings"] as? [[String: Any]]{
            
            for m in meaningsData{
                self.meanings.append(Meaning(with: m))
            }
            
        }
        self.parseAudio(info)
    }
    
    private func parseAudio(_ info: [String : Any]){
        
        if let phonetics = info["phonetics"] as? [[String: Any]] {
            
            for ph in phonetics {
                
                let audioUrl = ph["audio"] as? String ?? ""
                
                if audioUrl.contains(".mp3"){
                    self.audioUrl = audioUrl
                    
                    break
                }
                
            }
        }
        
    }
}


class Meaning {
    
    var partOfSpeech = ""
    var definitions = [Definition]()
    
    init(with meaningData: [String : Any]) {
        
        self.partOfSpeech = meaningData["partOfSpeech"] as? String ?? ""
        
        if let definitionData = meaningData["definitions"] as? [[String: Any]] {
            self.definitions  = self.parseDefinitions(definitionData)
        }
        
    }
    
    func parseDefinitions(_ definitionsData: [[String : Any]]) -> [Definition] {
     
        var definitions = [Definition]()
        
        for obj in definitionsData {
            
            let definition = Definition(with:obj)
            
            definitions.append(definition)
            
        }
        
        return definitions
    }
}

class Definition {
    
    var wordDefinition      = ""
    var example             = ""
    var synonyms            = [String]()
    var antonyms            = [String]()
 
    init(with definitionData: [String : Any]) {
     
        self.wordDefinition = definitionData["definition"] as? String ?? ""
        self.example        = definitionData["example"]    as? String ?? ""
        self.synonyms       = definitionData["synonyms"] as? [String] ?? [String]()
        self.antonyms       = definitionData["antonyms"] as? [String] ?? [String]()
    }
}
