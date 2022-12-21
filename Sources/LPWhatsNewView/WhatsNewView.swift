//
//  WhatsNewView.swift
//  
//
//  Created by Lukas Pistrol on 15.12.22.
//

import SwiftUI

#if os(iOS)

/// A view that displays information on what is new in your app.
///
/// Usage:
/// ```swift
/// var items = [WhatsNewItem(...)]
/// var learnMoreLink = URL(string: "your-url")
///
/// var body: some View {
///   VStack {
///     // content
///   }
///   .sheet(isPresented: $showWhatsNew) {
///     WhatsNewView(items: items, learnMoreLink: link)
///   }
/// }
/// ```
public struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss

    public var items: [WhatsNewItem]
    public var learnMoreLink: URL?
    public var configuration: Configuration = .init()

    public var body: some View {
        ScrollView {
            titleSection
            listItems
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                if let learnMoreLink {
                    Link(destination: learnMoreLink) {
                        Text(configuration.learnMoreButton)
                    }
                }
                dismissButton
            }
        }
    }

    var titleSection: some View {
        Text(configuration.title)
            .font(.largeTitle.bold())
            .padding(.vertical, 60)
    }

    var listItems: some View {
        VStack(spacing: 20) {
            ForEach(items) { item in
                HStack(spacing: 20) {
                    if let color = item.color {
                        Image(systemName: item.systemImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, alignment: .center)
                            .foregroundColor(color)
                    } else {
                        Image(systemName: item.systemImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, alignment: .center)
                            .foregroundStyle(.tint)
                    }
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 40)
    }

    var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Text(configuration.continueButton)
                .frame(maxWidth: .infinity)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding()
    }

    /// A collection of configurations for ``WhatsNewView``.
    public struct Configuration {
        /// The large title on top
        public var title: String = "What's new?"

        /// The title of the learn more button
        public var learnMoreButton: String = "Learn more"

        /// The title of the continue button
        public var continueButton: String = "Continue"
    }
}

/// A type defining a what's new item.
public struct WhatsNewItem: Identifiable {
    public var id: UUID = UUID()

    /// The title for the item.
    public var title: String

    /// The subtitle for the item
    public var subtitle: String

    /// The SFSymbol for the item
    public var systemImage: String

    /// The color for the SFSymbol. If not set this will be the tint color of the view.
    public var color: Color?
}

struct WhatsNewView_Previews: PreviewProvider {
    static var items: [WhatsNewItem] {
        [
            .init(
                title: "Adipisicing non sit",
                subtitle: "Adipisicing non sit deserunt pariatur nulla adipisicing reprehenderit.",
                systemImage: "star.fill"
            ),
            .init(
                title: "Ut minim mollit minim",
                subtitle: "Ut minim mollit minim anim aliquip ut ipsum ea reprehenderit sunt nulla id nulla ad.",
                systemImage: "swift",
                color: .orange
            ),
            .init(
                title: "Ut officia",
                subtitle: "Ut officia deserunt ad laborum laboris.",
                systemImage: "lasso.and.sparkles",
                color: .pink
            ),
            .init(
                title: "Sunt laborum excepteur",
                subtitle: "Sunt laborum excepteur eu nulla laboris labore anim aliqua ad cillum.",
                systemImage: "paperplane.fill",
                color: .indigo
            )
        ]
    }

    static var link = URL(string: "https://google.com")

    static var previews: some View {
        WhatsNewView(items: items, learnMoreLink: link)
    }
}

#endif
