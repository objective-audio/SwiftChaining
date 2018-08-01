//
//  TestSendableValues.swift
//

import Foundation
import Chaining

extension Int: Relayable {
    public typealias SendValue = Int
}

extension String: Relayable {
    public typealias SendValue = String
}
