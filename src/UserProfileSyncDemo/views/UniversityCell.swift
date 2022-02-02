//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import Foundation
import UIKit

class UniversityCell : UITableViewCell  {
    
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var url:UILabel!
    @IBOutlet weak var location:UILabel!

    var nameValue:String? {
        didSet {
            updateUI()
        }
    }
    
    var urlValue:String? {
        didSet {
            updateUI()
        }
    }
    
    var locationValue:String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let nameValue = nameValue {
            self.name.text = nameValue
        }
        
        if let locationValue = locationValue {
            self.location.text = locationValue
        }
        
        if let urlValue = urlValue {
            self.url.text = urlValue
        }
        self.layoutIfNeeded()
        self.setNeedsDisplay()
        self.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            super.accessoryType = .checkmark
        }
    }
    
}
