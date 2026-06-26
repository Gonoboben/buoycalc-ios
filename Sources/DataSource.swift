import Foundation

// MARK: - Тип источника данных

enum DataSourceKind: String, CaseIterable, Identifiable, Codable {
    case educationalPreset = "Учебное значение"
    case userInput = "Пользовательский ввод"
    case manufacturerData = "Паспорт производителя"
    case engineeringReference = "Инженерный источник"

    var id: String { rawValue }
}

// MARK: - Источник данных элемента

struct ElementDataSource: Codable, Hashable {
    var kindRawValue: String
    var manufacturer: String
    var model: String
    var document: String
    var page: String
    var comment: String

    var kind: DataSourceKind {
        DataSourceKind(rawValue: kindRawValue) ?? .userInput
    }

    static let educational = ElementDataSource(
        kindRawValue: DataSourceKind.educationalPreset.rawValue,
        manufacturer: "",
        model: "",
        document: "",
        page: "",
        comment: "Учебное приближённое значение. Не использовать как паспортное значение для реального проектирования."
    )

    static let userInput = ElementDataSource(
        kindRawValue: DataSourceKind.userInput.rawValue,
        manufacturer: "",
        model: "",
        document: "",
        page: "",
        comment: "Значение введено пользователем вручную."
    )

    var shortDescription: String {
        var parts: [String] = [kind.rawValue]

        if !manufacturer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append(manufacturer)
        }

        if !model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append(model)
        }

        if !document.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append(document)
        }

        if !page.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("стр. \(page)")
        }

        return parts.joined(separator: " · ")
    }
}
