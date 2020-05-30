//  Created by Prathamesh Kowarkar on 30/05/20.

extension CodableUserDefaults {

    public struct Key {

        public let rawValue: String

    }

}

extension CodableUserDefaults.Key: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.rawValue = value
    }

}

extension CodableUserDefaults.Key: ExpressibleByStringInterpolation {}
