import SwiftUI
import UIKit

struct ReportPreviewView: View {
    var projectName: String
    var reportText: String

    var pdfData: Data

    @Environment(\.dismiss) private var dismiss
    @State private var copyMessage = ""
    @State private var isExportingReport = false
    @State private var isExportingPDF = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    Text(reportText)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }

                Divider()

                VStack(spacing: 10) {
                    Button(action: copyReport) {
                        Text("Скопировать отчёт")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        isExportingReport = true
                    }) {
                        Text("Сохранить отчёт в файл .md")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        isExportingPDF = true
                    }) {
                        Text("Сохранить PDF-отчёт с визуализацией")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.82))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    ShareLink(
                        item: reportText,
                        subject: Text("Отчёт BuoyCalc — \(projectName)"),
                        message: Text("Предварительный инженерный отчёт BuoyCalc")
                    ) {
                        Text("Поделиться отчётом")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    if !copyMessage.isEmpty {
                        Text(copyMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.08))
            }
            .navigationTitle("Предпросмотр отчёта")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
            .fileExporter(
                isPresented: $isExportingReport,
                document: ReportDocument(text: reportText),
                contentType: .buoyCalcMarkdown,
                defaultFilename: safeFileName()
            ) { result in
                switch result {
                case .success:
                    copyMessage = "Markdown-отчёт сохранён в файл."
                case .failure(let error):
                    copyMessage = "Не удалось сохранить файл: \(error.localizedDescription)"
                }
            }
            .fileExporter(
                isPresented: $isExportingPDF,
                document: PDFReportDocument(data: pdfData),
                contentType: .buoyCalcPDF,
                defaultFilename: safeFileName() + "_PDF"
            ) { result in
                switch result {
                case .success:
                    copyMessage = "PDF-отчёт сохранён в файл."
                case .failure(let error):
                    copyMessage = "Не удалось сохранить PDF: \(error.localizedDescription)"
                }
            }
        }
    }

    func safeFileName() -> String {
        let trimmed = projectName.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseName = trimmed.isEmpty ? "BuoyCalc_Report" : trimmed

        let allowedCharacters = CharacterSet.alphanumerics
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "-_"))

        let filtered = baseName.unicodeScalars.map { scalar in
            allowedCharacters.contains(scalar) ? Character(scalar) : "_"
        }

        let fileName = String(filtered)
            .replacingOccurrences(of: " ", with: "_")

        return "BuoyCalc_\(fileName)"
    }

    func copyReport() {
        UIPasteboard.general.string = reportText
        copyMessage = "Отчёт скопирован в буфер обмена."
    }
}

#Preview {
    ReportPreviewView(
        projectName: "Тестовый проект",
        reportText: """
        # BuoyCalc — предварительный инженерный отчёт

        ## 1. Итоговый вердикт

        ✅ Система предварительно подходит

        | Параметр | Значение |
        |---|---:|
        | Глубина | 50 м |
        | Запас плавучести | 365 кг |
        """,
        pdfData: Data()
    )
}
