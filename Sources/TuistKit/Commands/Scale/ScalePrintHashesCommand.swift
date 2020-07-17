import ArgumentParser
import Foundation
import TSCBasic
import TuistSupport

struct ScalePrintHashesCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "print-hashes",
                             abstract: "Print the hashes of the cacheable frameworks in the given project.")
    }

    @Option(
        name: .shortAndLong,
        help: "The path where the project will be generated."
    )
    var path: String?

    func run() throws {
        try ScalePrintHashesService().run(path: path.map { AbsolutePath($0) } ?? FileHandler.shared.currentPath)
    }
}