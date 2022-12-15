//
//  WhatsNewView.swift
//  
//
//  Created by Lukas Pistrol on 15.12.22.
//

import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss

    var items: [WhatsNewItem]
    var learnMoreLink: URL?

    var body: some View {
        ScrollView {
            titleSection
            listItems

        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                if let learnMoreLink {
                    Link(destination: learnMoreLink) {
                        Text("Learn more")
                    }
                }
                dismissButton
            }
        }
    }

    var titleSection: some View {
        Text("What's new?")
            .font(.largeTitle.bold())
            .padding(.vertical, 60)
    }

    var listItems: some View {
        VStack(spacing: 20) {
            ForEach(items) { item in
                HStack(spacing: 20) {
                    Image(systemName: item.systemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, alignment: .center)
                        .foregroundColor(item.color)
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
            Text("Continue")
                .frame(maxWidth: .infinity)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding()
    }
}

struct WhatsNewItem: Identifiable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var systemImage: String
    var color: Color
}

struct WhatsNewView_Previews: PreviewProvider {
    static var items: [WhatsNewItem] {
        [
            .init(
                title: "Adipisicing non sit",
                subtitle: "Adipisicing non sit deserunt pariatur nulla adipisicing reprehenderit cillum esse eiusmod dolore consequat.",
                systemImage: "star.fill",
                color: .yellow
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
        Color.white
            .sheet(isPresented: .constant(true)) {
                WhatsNewView(items: items, learnMoreLink: link)
                    .preferredColorScheme(.dark)
            }
    }
}
