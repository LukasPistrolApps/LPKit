//
//  LPJSONImporter.swift
//  
//
//  Created by Lukas Pistrol on 20.11.22.
//

import SwiftUI
import UniformTypeIdentifiers

public extension View {
    func jsonImporter<T: Decodable>(isPresented: Binding<Bool>,
                                    result: @escaping (Result<[T], Error>) -> Void) -> some View {
        modifier(LPJSONImporterViewModifier(isPresented: isPresented, result: result))
    }
}

struct LPJSONImporterViewModifier<T: Decodable>: ViewModifier {

    @ObservedObject private var model: LPJSONImporterViewModel<T>
    @Binding private var isPresented: Bool

    init(isPresented: Binding<Bool>, result: @escaping (Result<[T], Error>) -> Void) {
        self._model = .init(wrappedValue: .init(result: result))
        self._isPresented = isPresented
    }

    public func body(content: Content) -> some View {
        content
            .fileImporter(isPresented: $isPresented, allowedContentTypes: model.types) { result in
                switch result {
                case .success(let url):
                    model.readFile(url: url)
                case .failure(let error):
                    model.result(.failure(error))
                }
            }
    }
}

class LPJSONImporterViewModel<T: Decodable>: ObservableObject {

    @Published var url: URL?
    var result: (Result<[T], Error>) -> Void

    public init(
        result: @escaping (Result<[T], Error>) -> Void
    ) {
        self.result = result
    }

    func readFile(url: URL) {
        do {
            _ = url.startAccessingSecurityScopedResource()
            let content = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([T].self, from: content)
            self.result(.success(result))
            url.stopAccessingSecurityScopedResource()
        } catch {
            self.result(.failure(error))
        }
    }

    var types: [UTType] = UTType.types(
        tag: "json",
        tagClass: .filenameExtension,
        conformingTo: nil
    )
}
