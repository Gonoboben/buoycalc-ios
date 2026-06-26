import Foundation

// MARK: - Пользовательский якорь

struct UserAnchorDraft: Identifiable, Codable, Hashable {
    var id: String

    var name: String
    var type: String
    var material: String

    var weightAirKg: Double
    var volumeM3: Double
    var baseHoldingCoefficient: Double

    var note: String
    var dataSource: ElementDataSource? = nil

    var displayName: String {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Пользовательский якорь"
        }

        return name
    }

    var asPreset: AnchorPreset {
        AnchorPreset(
            id: "user:\(id)",
            name: name,
            type: type,
            material: material,
            weightAirKg: weightAirKg,
            volumeM3: volumeM3,
            baseHoldingCoefficient: baseHoldingCoefficient,
            note: note
        )
    }
}

// MARK: - Хранилище пользовательских якорей

enum UserAnchorStorage {
    private static let key = "BuoyCalc.userAnchors.v1"

    static func loadAll() -> [UserAnchorDraft] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([UserAnchorDraft].self, from: data)
        } catch {
            print("Ошибка загрузки пользовательских якорей: \(error.localizedDescription)")
            return []
        }
    }

    static func saveAll(_ anchors: [UserAnchorDraft]) {
        do {
            let data = try JSONEncoder().encode(anchors)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Ошибка сохранения пользовательских якорей: \(error.localizedDescription)")
        }
    }

    static func upsert(_ anchor: UserAnchorDraft) {
        var anchors = loadAll()

        if let index = anchors.firstIndex(where: { $0.id == anchor.id }) {
            anchors[index] = anchor
        } else {
            anchors.append(anchor)
        }

        saveAll(anchors)
    }

    static func delete(id: String) {
        let anchors = loadAll().filter { $0.id != id }
        saveAll(anchors)
    }
}
