//  Created by Prathamesh Kowarkar on 30/05/20.

import Foundation

internal let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dataDecodingStrategy = .base64
    decoder.dateDecodingStrategy = .iso8601
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(
        positiveInfinity: positiveInfinity,
        negativeInfinity: negativeInfinity,
        nan: nan
    )
    return decoder
} ()
