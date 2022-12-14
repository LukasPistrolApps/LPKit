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
    internal typealias File = (name: String, extension: String)

    @Published private var _items: [AcknowledgementItem] = []
    private var bundle: Bundle
    internal var file: File = ("Package", "resolved")

    public var items: [AcknowledgementItem] {
        self._items
    }

    /// Creates a new instance of ``Acknowledgements/Acknowledgements``
    /// - Parameter bundle: The bundle to use. Defaults to `.main`.
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    internal init(bundle: Bundle, file: File) {
        self.bundle = bundle
        self.file = file
    }

    /// Loads the package dependencies from `Package.resolved`.
    ///
    /// Items can be accessed with ``items``.
    /// - Parameter excluding: An array of strings. Packages with occurrences of
    /// these strings will not be included in the resulting list ``items``.
    public func loadPackages(excluding: [String] = []) {
        guard let url = bundle.url(forResource: file.name, withExtension: file.extension),
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

/// A representation of a single package dependency.
public struct AcknowledgementItem: Identifiable {
    /// A unique id of the item.
    public var id: UUID = UUID()

    /// The title of the package.
    public var title: String

    /// The url string of the package.
    public var urlString: String

    /// The version string of the package.
    public var version: String

    /// The url of the package if ``urlString`` is a valid url.
    public var url: URL? {
        URL(string: urlString)
    }
}
