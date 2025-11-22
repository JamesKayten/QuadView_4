//
//  ContentView.swift
//  QuadView_4
//
//  Created by Smallfavor on 11/2/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var centerDividerPosition: CGFloat = 200
    @State private var leftDividerPosition: CGFloat = 100
    @State private var rightDividerPosition: CGFloat = 100

    var body: some View {
        QuadView4(centerDividerPosition: $centerDividerPosition,
                  leftDividerPosition: $leftDividerPosition,
                  rightDividerPosition: $rightDividerPosition)
        }
    }


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
