import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MeasureTimeMacro: BodyMacro {
    // BodyMacro's expansion
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingBodyFor declaration: some SwiftSyntax.DeclSyntaxProtocol & SwiftSyntax.WithOptionalCodeBlockSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.CodeBlockItemSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self), let codeBlockItems = funcDecl.body?.statements.map({ $0.item }) else {
            return [
                """
                \(declaration.body?.statements)
                """
            ]
        }

        var existReturFlag: Bool = false

        let returnStatement = codeBlockItems
            .map { $0.as(ReturnStmtSyntax.self)}
            .compactMap { $0 }

        var callLoggerAddedCode = codeBlockItems
            .map { item in
                if item.is(ReturnStmtSyntax.self) {
                    existReturFlag = true
                    return """
                    measureTimeMacroLogger.stop()
                    \(item)
                    """
                } else {
                    return """
                    \(item)
                    """
                }
            }
            .joined(separator: "\n")

        if !existReturFlag {
            callLoggerAddedCode.append(
                """
                \n
                measureTimeMacroLogger.stop()
                """
            )
        }

        return [
            """
            let measureTimeMacroLogger = MeasureTimeLogger()
            \(raw: callLoggerAddedCode)
            """
        ]
    }
}

@main
struct MeasuringMethodExecutionTimeMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MeasureTimeMacro.self,
    ]
}
