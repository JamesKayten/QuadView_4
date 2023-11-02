//
//  Item.swift
//  QuadView_4
//
//  Created by Smallfavor on 11/2/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
