//
//  TestSendableValues.swift
//

import Foundation
import SwiftChaining

extension Int: Relayable {
    public typealias SendValue = Int
}

extension String: Relayable {
    public typealias SendValue = String
}
