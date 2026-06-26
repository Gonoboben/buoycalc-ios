import SwiftUI
import UniformTypeIdentifiers

// MARK: - Тип файла PDF

extension UTType {
    static var buoyCalcPDF: UTType {
        .pdf
    }
}

// MARK: - PDF-документ отчёта

struct PDFReportDocument: FileDocument {

    static var readableContentTypes: [UTType] {
        [.pdf]
    }

    var data: Data

    init(data: Data = Data()) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        self.data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
