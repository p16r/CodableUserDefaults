//  Created by Prathamesh Kowarkar on 30/05/20.

import Foundation

internal let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dataEncodingStrategy = .base64
    encoder.dateEncodingStrategy = .iso8601
    encoder.nonConformingFloatEncodingStrategy = .convertToString(
        positiveInfinity: positiveInfinity,
        negativeInfinity: negativeInfinity,
        nan: nan
    )
    return encoder
} ()
