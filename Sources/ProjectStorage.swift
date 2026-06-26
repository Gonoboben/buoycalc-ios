import Foundation

// MARK: - Черновик проекта для сохранения

struct BuoyCalcDraft: Codable {

    // Проект
    var projectName: String

    // Условия среды
    var waterDensity: String
    var depth: String
    var currentSpeed: String
    var waveHeight: String
    var wavePeriod: String
    var selectedSeabedPresetId: String

    // Буй
    var selectedBuoyPresetId: String?
    var selectedBuoyShapeRawValue: String
    var buoyDiameter: String
    var buoyHeight: String
    var buoyCustomVolume: String
    var buoyWeight: String
    var buoyDragCoefficient: String

    // Швартовная линия
    var systemSafetyFactor: String

    // Новая модель v2.9: последовательность элементов от буя к якорю
    var mooringAssemblyItems: [MooringAssemblyItemDraft]?

    // Старые поля v2.8 и ниже оставлены для совместимости
    var selectedSegment1PresetId: String
    var segment1Length: String

    var useSegment2: Bool
    var selectedSegment2PresetId: String
    var segment2Length: String

    var useSegment3: Bool
    var selectedSegment3PresetId: String
    var segment3Length: String

    // Соединители
    var useConnector1: Bool
    var selectedConnector1PresetId: String
    var connector1Count: String

    var useConnector2: Bool
    var selectedConnector2PresetId: String
    var connector2Count: String

    var useConnector3: Bool
    var selectedConnector3PresetId: String
    var connector3Count: String

    // Прибор
    var payloadName: String
    var payloadWeightAir: String
    var payloadVolume: String
    var payloadProjectedArea: String
    var payloadDragCoefficient: String

    // Якорь
    var selectedAnchorPresetId: String
    var anchorName: String?
    var anchorType: String?
    var anchorMaterial: String?
    var anchorWeightAir: String
    var anchorVolume: String
    var anchorBaseHoldingCoefficient: String
}

// MARK: - Сохранённый проект

struct SavedBuoyCalcProject: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var updatedAt: Date
    var draft: BuoyCalcDraft

    var displayName: String {
        name.isEmpty ? "Без названия" : name
    }
}

// MARK: - Хранилище проектов

enum ProjectStorage {
    private static let projectsKey = "BuoyCalc.savedProjects.v1"

    static func loadAll() -> [SavedBuoyCalcProject] {
        guard let data = UserDefaults.standard.data(forKey: projectsKey) else {
            return []
        }

        do {
            let projects = try JSONDecoder().decode([SavedBuoyCalcProject].self, from: data)
            return projects.sorted { $0.updatedAt > $1.updatedAt }
        } catch {
            print("Ошибка загрузки списка проектов: \(error.localizedDescription)")
            return []
        }
    }

    static func saveAll(_ projects: [SavedBuoyCalcProject]) {
        do {
            let data = try JSONEncoder().encode(projects)
            UserDefaults.standard.set(data, forKey: projectsKey)
        } catch {
            print("Ошибка сохранения списка проектов: \(error.localizedDescription)")
        }
    }

    static func upsert(_ project: SavedBuoyCalcProject) {
        var projects = loadAll()

        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
        } else {
            projects.append(project)
        }

        saveAll(projects.sorted { $0.updatedAt > $1.updatedAt })
    }

    static func delete(id: String) {
        let projects = loadAll().filter { $0.id != id }
        saveAll(projects)
    }

    static func deleteAll() {
        UserDefaults.standard.removeObject(forKey: projectsKey)
    }
}
