//
//  LPDocumentPicker.swift
//  
//
//  Created by Lukas Pistrol on 20.11.22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
public struct LPDocumentPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    public init(filePath: Binding<URL?>, types: [UTType]) {
        self._filePath = filePath
        self.types = types
    }

    @Binding private var filePath: URL?
    private var types: [UTType]

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> some UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    public class Coordinator: NSObject, UIDocumentPickerDelegate {

        var parent: LPDocumentPicker

        init(_ parent: LPDocumentPicker) {
            self.parent = parent
        }

        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            parent.filePath = url
        }

        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
}
#endif
