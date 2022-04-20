//
//  ViewManager.swift
//  Dictionary
//
//  Created by Group2 on 16/04/22.
//

import Foundation
import UIKit

struct ViewManager {
    
    static func setBookmarkImage(for sender: UIButton) -> Bool{
        
        let image  = sender.image(for: .normal)
        //symbol(system: bookmark) {17.5, 20}
        
        let bookmarkNormal = UIImage(systemName: "bookmark")
        let bookmarkFilled = UIImage(systemName: "bookmark.fill")
        
        if image == bookmarkNormal{
            sender.setImage(bookmarkFilled, for: .normal)
        }else{
            sender.setImage(bookmarkNormal, for: .normal)
        }
        
        return (image == bookmarkNormal)
        
    }
}
