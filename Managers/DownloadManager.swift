import Foundation

final class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    static let shared = DownloadManager()

    @Published var progressByEpisode: [String: Double] = [:] // 0.0 - 1.0
    private lazy var session: URLSession = {
        let cfg = URLSessionConfiguration.background(withIdentifier: "com.animox.downloads")
        return URLSession(configuration: cfg, delegate: self, delegateQueue: nil)
    }()

    func enqueue(episodeId: String, from url: URL) {
        let task = session.downloadTask(with: url)
        task.taskDescription = episodeId
        task.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let episodeId = downloadTask.taskDescription else { return }
        let fm = FileManager.default
        do {
            let destDir = try downloadsDir()
            let destURL = destDir.appendingPathComponent("\(episodeId).mp4")
            try? fm.removeItem(at: destURL)
            try fm.moveItem(at: location, to: destURL)
            DispatchQueue.main.async {
                self.progressByEpisode[episodeId] = 1.0
            }
        } catch {
            print("Move failed: \(error)")
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let episodeId = downloadTask.taskDescription else { return }
        let progress = totalBytesExpectedToWrite > 0 ? Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) : 0
        DispatchQueue.main.async {
            self.progressByEpisode[episodeId] = progress
        }
    }

    private func downloadsDir() throws -> URL {
        let appSupport = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dir = appSupport.appendingPathComponent("Downloads", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }
}
