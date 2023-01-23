import UIKit

extension Data {

    /// A method to measure the size of data in terms of Megabytes
    /// - Returns: The size of Data object in Megabytes
    func sizeInMegabytes() -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useMB]
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: Int64(count))
    }
}
