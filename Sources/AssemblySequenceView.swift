import SwiftUI

// MARK: - Визуальная цепочка постановки

struct AssemblySequenceView: View {
    var buoyTitle: String
    var items: [MooringAssemblyItemDraft]
    var anchorTitle: String

    var enabledItems: [MooringAssemblyItemDraft] {
        items.filter { $0.isEnabled }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Цепочка постановки")
                .font(.headline)

            Text("Упрощённая схема сборки сверху вниз: от буя к якорю.")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                sequenceNode(
                    title: buoyTitle.isEmpty ? "Буй" : buoyTitle,
                    subtitle: "Верхняя плавучая точка",
                    icon: "circle.tophalf.filled",
                    color: .blue
                )

                ForEach(Array(enabledItems.enumerated()), id: \.element.id) { index, item in
                    connectorArrow()

                    sequenceNode(
                        title: item.title.isEmpty ? item.kind.shortTitle : item.title,
                        subtitle: subtitle(for: item, index: index),
                        icon: icon(for: item.kind),
                        color: color(for: item.kind)
                    )
                }

                connectorArrow()

                sequenceNode(
                    title: anchorTitle.isEmpty ? "Якорь" : anchorTitle,
                    subtitle: "Нижняя точка удержания",
                    icon: "square.fill",
                    color: .brown
                )
            }
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(16)
    }

    func sequenceNode(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(color.opacity(0.09))
        .cornerRadius(12)
    }

    func connectorArrow() -> some View {
        Image(systemName: "arrow.down")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    func subtitle(for item: MooringAssemblyItemDraft, index: Int) -> String {
        switch item.kind {
        case .connector:
            return "Соединитель · \(item.countText) шт."
        case .line:
            return "Буйреп / линия · \(item.lengthText) м"
        case .payload:
            return "Прибор / нагрузка · \(item.weightAirText) кг"
        }
    }

    func icon(for kind: MooringAssemblyItemKind) -> String {
        switch kind {
        case .connector:
            return "link"
        case .line:
            return "line.diagonal"
        case .payload:
            return "sensor.tag.radiowaves.forward"
        }
    }

    func color(for kind: MooringAssemblyItemKind) -> Color {
        switch kind {
        case .connector:
            return .orange
        case .line:
            return .cyan
        case .payload:
            return .purple
        }
    }
}

#Preview {
    AssemblySequenceView(
        buoyTitle: "Цилиндрический буй",
        items: MooringAssemblyItemDraft.defaultItems(),
        anchorTitle: "Бетонный якорь"
    )
    .padding()
}
