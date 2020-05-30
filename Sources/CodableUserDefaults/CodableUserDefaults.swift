//  Created by Prathamesh Kowarkar on 30/05/20.

import Foundation
import Combine

@propertyWrapper
public struct CodableUserDefaults<Value: Codable> {

    private let key: Key
    private let userDefaults: UserDefaults
    private let notificationCenter: NotificationCenter?
    private let valueFor: (String) -> Any?
    private let setValue: (Value, String) -> Void

    private var notificationName: Notification.Name {
        .init("\(Self.self).\(key.rawValue)")
    }

    public init(
        wrappedValue: Value?,
        key: Key,
        userDefaults: UserDefaults,
        notificationCenter: NotificationCenter?
    ) {
        self.init(
            key: key,
            userDefaults: userDefaults,
            notificationCenter: notificationCenter
        )
        self.wrappedValue = wrappedValue
    }

    public init(
        key: Key,
        userDefaults: UserDefaults,
        notificationCenter: NotificationCenter?
    ) {
        self.key = key
        self.userDefaults = userDefaults
        self.notificationCenter = notificationCenter

        if Value.self is UserDefaultsRepresentable.Type {
            valueFor = userDefaults.value(forKey:)
            setValue = userDefaults.setValue(_:forKey:)
        } else {
            valueFor = { key in
                userDefaults.data(forKey: key).flatMap {
                    try? decoder.decode(Value?.self, from: $0)
                }
            }
            setValue = { value, key in
                userDefaults.set(try? encoder.encode(value), forKey: key)
            }
        }
    }

    public var wrappedValue: Value? {
        get { valueFor(key.rawValue) as? Value }
        set {
            switch newValue {
                case .some(let value): setValue(value, key.rawValue)
                case .none: userDefaults.removeObject(forKey: key.rawValue)
            }
            notificationCenter?.post(name: notificationName, object: newValue)
        }
    }

    public var projectedValue: AnyPublisher<Value?, Never>? {
        notificationCenter?
            .publisher(for: notificationName)
            .map { $0.object as? Value }
            .eraseToAnyPublisher()
    }

}
