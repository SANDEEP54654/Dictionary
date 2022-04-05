//
//  NavigationHelper.swift
//  Dictionary
//
//  Created by Group2 on 22/03/22.
//

import Foundation
import UIKit


enum VCIdentifier: String {
    case detail = "DetailVC"
    case history = "HistoryVC"
}

struct NavigationHelper {
    
    static func viewController(with id: VCIdentifier) -> UIViewController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: id.rawValue)
    }
    
}
