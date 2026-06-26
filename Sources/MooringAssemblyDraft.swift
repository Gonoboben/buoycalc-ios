import Foundation

// MARK: - Тип элемента последовательности постановки

enum MooringAssemblyItemKind: String, CaseIterable, Identifiable, Codable {
    case connector = "Соединитель"
    case line = "Буйреп / линия"
    case payload = "Прибор / нагрузка"

    var id: String {
        rawValue
    }

    var shortTitle: String {
        switch self {
        case .connector:
            return "Соединитель"
        case .line:
            return "Линия"
        case .payload:
            return "Прибор"
        }
    }
}

// MARK: - Элемент последовательности постановки

struct MooringAssemblyItemDraft: Identifiable, Codable, Hashable {
    var id: String
    var kindRawValue: String

    // Общие поля
    var title: String
    var isEnabled: Bool

    // Для линии и соединителей
    var presetId: String

    // Для линии
    var lengthText: String

    // Для соединителей
    var countText: String

    // Для прибора / нагрузки
    var weightAirText: String
    var volumeText: String
    var projectedAreaText: String
    var dragCoefficientText: String

    var kind: MooringAssemblyItemKind {
        MooringAssemblyItemKind(rawValue: kindRawValue) ?? .line
    }

    static func connector(
        title: String,
        presetId: String,
        countText: String
    ) -> MooringAssemblyItemDraft {
        MooringAssemblyItemDraft(
            id: UUID().uuidString,
            kindRawValue: MooringAssemblyItemKind.connector.rawValue,
            title: title,
            isEnabled: true,
            presetId: presetId,
            lengthText: "0",
            countText: countText,
            weightAirText: "0",
            volumeText: "0",
            projectedAreaText: "0",
            dragCoefficientText: "1.0"
        )
    }

    static func line(
        title: String,
        presetId: String,
        lengthText: String
    ) -> MooringAssemblyItemDraft {
        MooringAssemblyItemDraft(
            id: UUID().uuidString,
            kindRawValue: MooringAssemblyItemKind.line.rawValue,
            title: title,
            isEnabled: true,
            presetId: presetId,
            lengthText: lengthText,
            countText: "1",
            weightAirText: "0",
            volumeText: "0",
            projectedAreaText: "0",
            dragCoefficientText: "1.0"
        )
    }

    static func payload(
        title: String,
        weightAirText: String,
        volumeText: String,
        projectedAreaText: String,
        dragCoefficientText: String
    ) -> MooringAssemblyItemDraft {
        MooringAssemblyItemDraft(
            id: UUID().uuidString,
            kindRawValue: MooringAssemblyItemKind.payload.rawValue,
            title: title,
            isEnabled: true,
            presetId: "",
            lengthText: "0",
            countText: "1",
            weightAirText: weightAirText,
            volumeText: volumeText,
            projectedAreaText: projectedAreaText,
            dragCoefficientText: dragCoefficientText
        )
    }

    static func defaultItems() -> [MooringAssemblyItemDraft] {
        [
            .connector(
                title: "Скоба под буем",
                presetId: "shackle_55",
                countText: "1"
            ),
            .line(
                title: "Верхний буйреп",
                presetId: "polyester_20",
                lengthText: "45"
            ),
            .connector(
                title: "Вертлюг",
                presetId: "swivel_60",
                countText: "1"
            ),
            .payload(
                title: "ADCP",
                weightAirText: "40",
                volumeText: "0",
                projectedAreaText: "0.05",
                dragCoefficientText: "1.0"
            ),
            .connector(
                title: "Скоба у нижнего участка",
                presetId: "shackle_55",
                countText: "1"
            ),
            .line(
                title: "Нижний участок цепи",
                presetId: "chain_10",
                lengthText: "10"
            )
        ]
    }
}
