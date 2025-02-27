//
//  DownHTMLRenderable.swift
//  Down
//
//  Created by Rob Phillips on 5/28/16.
//  Copyright © 2016-2019 Down. All rights reserved.
//

import Foundation
import libcmark

public protocol DownHTMLRenderable: DownRenderable {

    func toHTML(_ options: DownOptions) throws -> String

}

extension DownHTMLRenderable {

    /// Generates an HTML string from the `markdownString` property.
    ///
    /// - Parameters:
    ///     -  options: `DownOptions` to modify parsing or rendering, defaulting to `.default`.
    ///
    /// - Returns:
    ///     An HTML string.
    ///
    /// - Throws:
    ///     `DownErrors` depending on the scenario.

    public func toHTML(_ options: DownOptions = .default) throws -> String {
        return try markdownString.toHTML(options)
    }

}

public struct DownHTMLRenderer {

    /// Generates an HTML string from the given abstract syntax tree.
    ///
    /// **Note:** caller is responsible for calling `cmark_node_free(ast)` after this returns.
    ///
    /// - Parameters:
    ///     - ast: The `cmark_node` representing the abstract syntax tree.
    ///     - options: `DownOptions` to modify parsing or rendering, defaulting to `.default`.
    ///
    /// - Returns:
    ///     An HTML string.
    ///
    /// - Throws:
    ///     `ASTRenderingError` if the AST could not be converted.

    public static func astToHTML(_ ast: CMarkNode, options: DownOptions = .default) throws -> String {
        guard let cHTMLString = cmark_render_html(ast, options.rawValue, nil) else {
            throw DownErrors.astRenderingError
        }
        
        defer {
            free(cHTMLString)
        }

        guard let htmlString = String(cString: cHTMLString, encoding: String.Encoding.utf8) else {
            throw DownErrors.astRenderingError
        }

        return htmlString
    }
    
    /// Generates an HTML string from the given abstract syntax tree.
    /// - Parameters:
    ///   - ast: cmark_node` representing the abstract syntax tree.
    ///   - extensions: GFM extensions to modify parsing or rendering
    ///   - options: `DownOptions` to modify parsing or rendering, defaulting to `.default`.
    /// - Returns: An HTML string.
    public static func astToHTMLFromGFM(_ ast: CMarkNode, extensions: UnsafeMutablePointer<cmark_llist>?, options: DownOptions = .default) throws -> String {
        guard let cHTMLString = cmark_render_html(ast, options.rawValue, extensions) else {
            throw DownErrors.astRenderingError
        }
        
        defer {
            free(cHTMLString)
        }

        guard let htmlString = String(cString: cHTMLString, encoding: String.Encoding.utf8) else {
            throw DownErrors.astRenderingError
        }

        return htmlString
    }

}
