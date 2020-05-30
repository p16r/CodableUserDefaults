//  Created by Prathamesh Kowarkar on 30/05/20.

import Foundation

internal  protocol      UserDefaultsRepresentable {}

extension Int:          UserDefaultsRepresentable {}

extension Double:       UserDefaultsRepresentable {}

extension Float:        UserDefaultsRepresentable {}

extension Bool:         UserDefaultsRepresentable {}

extension String:       UserDefaultsRepresentable {}

extension URL:          UserDefaultsRepresentable {}

extension Data:         UserDefaultsRepresentable {}

extension Array:        UserDefaultsRepresentable
    where Element:      UserDefaultsRepresentable {}

extension Dictionary:   UserDefaultsRepresentable
    where Key ==        String,
          Value:        UserDefaultsRepresentable {}
