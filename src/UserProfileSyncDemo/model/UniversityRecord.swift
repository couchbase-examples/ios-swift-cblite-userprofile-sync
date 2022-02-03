//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import Foundation

typealias Universities = [UniversityRecord]

struct UniversityRecord
    : CustomStringConvertible{
    
    var alphaTwoCode:String?
    var country:String?
    var domains:[String]?
    var name:String?
    var webPages:[String]?
    
    var description: String {
        return "name = \(String(describing: name)), country = \(String(describing: country)), domains = \(String(describing: domains)), webPages = \(String(describing: webPages)), alphaTwoCode = \(String(describing: alphaTwoCode))"
    }
}
