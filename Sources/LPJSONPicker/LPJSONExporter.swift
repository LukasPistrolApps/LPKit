//
//  LPJsonExporter.swift
//  
//
//  Created by Lukas Pistrol on 20.11.22.
//

import SwiftUI
import UniformTypeIdentifiers

public extension View {
    func jsonExporter<T: Encodable>(
        isPresented: Binding<Bool>,
        data: [T],
        fileName: String,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) -> some View {
        modifier(JSONExporter(isPresented: isPresented, data: data, fileName: fileName, onCompletion: onCompletion))
    }
}

struct JSONExporter<T: Encodable>: ViewModifier {

    @StateObject private var model: LPJSONExporterViewModel<T>
    @Binding private var isPresented: Bool
    var completion: (Result<URL, Error>) -> Void

    init(isPresented: Binding<Bool>,
         data: [T],
         fileName: String,
         onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self._isPresented = isPresented
        self._model = .init(wrappedValue: .init(data: data, fileName: fileName))
        self.completion = onCompletion
    }

    func body(content: Content) -> some View {
        content
            .fileExporter(isPresented: $isPresented,
                          document: model.document,
                          contentType: .json,
                          onCompletion: completion)
    }
}

class LPJSONExporterViewModel<T: Encodable>: ObservableObject {
    @Published var data: [T]
    @Published var document: JSONFile?
    var fileName: String

    public init(data: [T], fileName: String) {
        self.data = data
        self.fileName = fileName
        createFile()
    }

    func createFile() {
        do {
            let data = try JSONEncoder().encode(data)
            let json = try JSONSerialization.jsonObject(with: data)
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            self.document = JSONFile(data: jsonData, fileName: fileName)
        } catch {
            print(error)
        }
    }
}

struct JSONFile: FileDocument {
    static var readableContentTypes: [UTType] = [.json]

    var text = ""
    var fileName: String?

    init(text: String = "", fileName: String) {
        self.text = text
        self.fileName = fileName
    }

    init(data: Data, fileName: String) {
        self.text = String(decoding: data, as: UTF8.self)
        self.fileName = fileName
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        if let fileName {
            fileWrapper.preferredFilename = fileName
        }
        return fileWrapper
    }
}
