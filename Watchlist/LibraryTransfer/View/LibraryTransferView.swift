import SwiftUI
import UniformTypeIdentifiers

struct LibraryBackupFile: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    let data: Data
    init(document: WatchLibraryDocument) throws { data = try LibraryBackupCodec.encode(document) }
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { throw LibraryTransferError.invalidBackup }
        _ = try LibraryBackupCodec.decode(data)
        self.data = data
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

struct LibraryTransferView: View {
    @State var presenter: LibraryTransferPresenterImpl
    @State private var export: LibraryBackupFile?
    @State private var exporting = false
    @State private var importing = false

    var body: some View {
        Form {
            Section("Library backup") {
                Text("Export includes saved titles, lists, ratings and episode progress. "
                     + "Artist favorites stay on this device.")
                    .font(.footnote).foregroundStyle(.secondary)
                Button("Export backup") {
                    do {
                        export = try LibraryBackupFile(document: presenter.store.document)
                        exporting = true
                    } catch { presenter.error = error }
                }
                Button("Import backup") { importing = true }
            }
            .disabled(!presenter.store.isLoaded || presenter.store.isSaving)
        }
        .navigationTitle("Backup")
        .navigationBarTitleDisplayMode(.inline)
        .fileExporter(
            isPresented: $exporting, document: export, contentType: .json, defaultFilename: "Watchlist-backup"
        ) {
            if case .failure(let error) = $0 { presenter.error = error }
        }
        .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { result in
            switch result {
            case .success(let url): Task { await presenter.previewImport(url) }
            case .failure(let error): presenter.error = error
            }
        }
        .confirmationDialog("Merge backup with your library?", isPresented: Binding(
            get: { presenter.importPreview != nil },
            set: { if !$0 { presenter.importPreview = nil } }
        ), titleVisibility: .visible) {
            Button("Merge backup: \(presenter.importPreview?.entries.count ?? 0) titles, "
                   + "\(presenter.importPreview?.lists?.count ?? 0) lists") {
                if let incoming = presenter.importPreview {
                    Task { await presenter.mergeImport(incoming) }
                }
            }
            Button("Cancel", role: .cancel) { presenter.importPreview = nil }
        } message: {
            Text("Latest title/list edits and deletions win. Existing items absent from the backup are kept.")
        }
        .errorAlert(error: $presenter.error)
        .task { await presenter.store.load() }
    }
}
