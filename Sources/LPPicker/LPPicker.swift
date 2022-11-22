//
//  LPPicker.swift
//  
//
//  Created by Lukas Pistrol on 22.11.22.
//

import SwiftUI

public struct LPPicker<Label, Item>: View where Label: View, Item: Identifiable {

    private var items: [Item]
    @Binding private var selection: Item
    private var label: Label
    private var keyPath: KeyPath<Item, String>

    public init(
        items: [Item],
        selection: Binding<Item>,
        title keyPath: KeyPath<Item, String>,
        label: @escaping () -> Label
    ) {
        self.items = items
        self._selection = selection
        self.label = label()
        self.keyPath = keyPath
    }

    public var body: some View {
        LabeledContent {
            Menu {
                ForEach(items) { item in
                    Button { selection = item } label: {
                        let isSelected = selection.id == item.id
                        SwiftUI.Label(item[keyPath: keyPath], systemImage: isSelected ? "checkmark" : "")
                    }
                }
            } label: {
                HStack(spacing: .mediumSmallSpacing) {
                    Text(selection[keyPath: keyPath])
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "chevron.up.chevron.down")
                        .imageScale(.small)
                }
                .foregroundColor(.secondary)
            }
            .menuStyle(.button)
            .buttonStyle(.plain)
            .transaction { $0.animation = nil }
        } label: {
            label
        }
    }
}
