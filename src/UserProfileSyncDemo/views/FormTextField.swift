//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import UIKit
import Foundation

@IBDesignable
class FormTextField : UITextField {
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
}
