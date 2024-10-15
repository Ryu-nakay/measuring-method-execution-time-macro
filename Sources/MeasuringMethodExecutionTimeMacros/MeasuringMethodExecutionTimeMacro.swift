import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TimeMeasureableMacro: MemberAttributeMacro {
    // MemberAttributeMacro's expansion
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AttributeSyntax] {
        guard let _ = member.as(FunctionDeclSyntax.self) else {
            return []
        }

        return [
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(
                    name: .identifier("MeasureTime")
                )
            ),
        ]
    }
}

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

        var callLoggerAddedCode = codeBlockItems
            .map { item in
                if item.is(ReturnStmtSyntax.self) {
                    existReturFlag = true
                    return """
                    measureTimeMacroLogger.stop(className: "\\(type(of: self))")
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
                measureTimeMacroLogger.stop(className:  "\\(type(of: self))")
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
        TimeMeasureableMacro.self,
    ]
}
