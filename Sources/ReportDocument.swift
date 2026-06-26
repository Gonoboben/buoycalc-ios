import SwiftUI
import UniformTypeIdentifiers

// MARK: - Тип файла Markdown

extension UTType {
    static var buoyCalcMarkdown: UTType {
        UTType(filenameExtension: "md") ?? .plainText
    }
}

// MARK: - Документ отчёта

struct ReportDocument: FileDocument {

    static var readableContentTypes: [UTType] {
        [.plainText, .buoyCalcMarkdown]
    }

    var text: String

    init(text: String = "") {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents,
           let string = String(data: data, encoding: .utf8) {
            text = string
        } else {
            text = ""
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
