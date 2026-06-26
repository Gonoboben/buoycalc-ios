import Foundation

// MARK: - Пользовательский соединительный элемент

struct UserConnectorDraft: Identifiable, Codable, Hashable {
    var id: String

    var name: String
    var type: String

    var weightAirKg: Double
    var volumeM3: Double

    var breakingLoadKn: Double
    var projectedAreaM2: Double
    var dragCoefficient: Double

    var note: String
    var dataSource: ElementDataSource? = nil

    var displayName: String {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "\(type), MBL \(Int(breakingLoadKn)) кН"
        }

        return name
    }

    var asPreset: ConnectorPreset {
        ConnectorPreset(
            id: "user:\(id)",
            name: name,
            type: type,
            weightAirKg: weightAirKg,
            volumeM3: volumeM3,
            breakingLoadKn: breakingLoadKn,
            projectedAreaM2: projectedAreaM2,
            dragCoefficient: dragCoefficient,
            note: note
        )
    }
}

// MARK: - Хранилище пользовательских соединителей

enum UserConnectorStorage {
    private static let key = "BuoyCalc.userConnectors.v1"

    static func loadAll() -> [UserConnectorDraft] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([UserConnectorDraft].self, from: data)
        } catch {
            print("Ошибка загрузки пользовательских соединителей: \(error.localizedDescription)")
            return []
        }
    }

    static func saveAll(_ connectors: [UserConnectorDraft]) {
        do {
            let data = try JSONEncoder().encode(connectors)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Ошибка сохранения пользовательских соединителей: \(error.localizedDescription)")
        }
    }

    static func upsert(_ connector: UserConnectorDraft) {
        var connectors = loadAll()

        if let index = connectors.firstIndex(where: { $0.id == connector.id }) {
            connectors[index] = connector
        } else {
            connectors.append(connector)
        }

        saveAll(connectors)
    }

    static func delete(id: String) {
        let connectors = loadAll().filter { $0.id != id }
        saveAll(connectors)
    }
}
