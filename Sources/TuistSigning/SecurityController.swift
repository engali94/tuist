import Basic
import TuistSupport

protocol SecurityControlling {
    func decodeFile(at path: AbsolutePath) throws -> String
    func importCertificate(at path: AbsolutePath) throws
}

final class SecurityController: SecurityControlling {
    private let keychainPath: AbsolutePath = FileHandler.shared.homeDirectory.appending(RelativePath("Library/Keychains/login.keychain"))

    func decodeFile(at path: AbsolutePath) throws -> String {
        try System.shared.capture("/usr/bin/security", "cms", "-D", "-i", path.pathString)
    }

    func importCertificate(at path: AbsolutePath) throws {
        do {
            try System.shared.run("/usr/bin/security", "-p", keychainPath.pathString, "import", path.pathString)
        } catch {
            if let systemError = error as? TuistSupport.SystemError,
                systemError.description.contains("The specified item already exists in the keychain") {
                logger.debug("Certificate at \(path) is already present in keychain")
                return
            } else {
                throw error
            }
        }
        logger.debug("Imported certificate at \(path.pathString)")
    }
}