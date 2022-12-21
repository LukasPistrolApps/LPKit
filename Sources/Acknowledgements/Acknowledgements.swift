//
//  Acknowledgements.swift
//  
//
//  Created by Lukas Pistrol on 21.12.22.
//

import SwiftUI

/// A class which parses package dependencies from the
/// bundle's `Package.resolved` file.
///
/// Usage:
/// ```swift
/// // create an instance of Acknowledgements
/// let model = Acknowledgements(bundle: .main)
///
/// // load the packages, optionally exclude items containing
/// model.loadPackages(excluding: ["SwiftLint"])
///
/// // access the `items`
/// let items = model.items
/// ```
///
/// - Attention: The `Package.resolved` file must
/// be added to your target as a resource.
public class Acknowledgements: ObservableObject {

    @Published private var _items: [AcknowledgementItem] = []
    private var bundle: Bundle

    public var items: [AcknowledgementItem] {
        self._items
    }

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    public func loadPackages(excluding: [String] = []) {
        guard let url = bundle.url(forResource: "Package", withExtension: "resolved"),
              let data = try? Data(contentsOf: url),
              let root = try? JSONDecoder().decode(PackageRoot.self, from: data) else {
            return
        }
        self._items = root.pins.map {
            AcknowledgementItem(
                title: $0.friendlyName,
                urlString: $0.location,
                version: $0.state.version ?? $0.state.branch ?? ""
            )
        }
        .filter { item in
            if !excluding.isEmpty {
                return !excluding.contains { item.title.contains($0) }
            }
            return true
        }
    }

    private struct PackageRoot: Codable {
        let pins: [PackagePin]
        let version: Int
    }

    private struct PackagePin: Codable {
        let identity: String
        let location: String
        let state: PackagePinState

        var friendlyName: String {
            guard let lastComponent = location.split(separator: "/").last else {
                return identity
            }
            return lastComponent.replacingOccurrences(of: ".git", with: "")
        }
    }

    private struct PackagePinState: Codable {
        let branch: String?
        let version: String?
        let revision: String
    }
}

public struct AcknowledgementItem: Identifiable {
    public var id: UUID = UUID()

    public var title: String
    public var urlString: String
    public var version: String

    public var url: URL? {
        URL(string: urlString)
    }
}

@available(tvOS 16.0, *)
@available(watchOS 9.0, *)
@available(macOS 13.0, *)
@available(iOS 16.0, *)
public struct AcknowledgementListRow: View {

    private let item: AcknowledgementItem

    public init(_ item: AcknowledgementItem) {
        self.item = item
    }

    @ViewBuilder
    public var body: some View {
        if let url = item.url {
            Link(destination: url) {
                LabeledContent(item.title, value: item.version)
            }
        }
    }
}
