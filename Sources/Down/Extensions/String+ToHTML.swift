//
//  String+ToHTML.swift
//  Down
//
//  Created by Rob Phillips on 6/1/16.
//  Copyright © 2016-2019 Down. All rights reserved.
//

import Foundation
import libcmark

extension String {

    /// Generates an HTML string from the contents of the string (self), which should contain CommonMark Markdown.
    ///
    /// - Parameters:
    ///     - options: `DownOptions` to modify parsing or rendering, defaulting to `.default`.
    /// - Returns:
    ///     An HTML string.
    ///
    /// - Throws:
    ///     `DownErrors` depending on the scenario.

    public func toHTML(_ options: DownOptions = .default) throws -> String {
        let ast = try DownASTRenderer.stringToAST(self, options: options)
        let html = try DownHTMLRenderer.astToHTML(ast, options: options)
        cmark_node_free(ast)
        return html
    }
    
    /// Generates an HTML string from the contents of the string (self), which should contain CommonMark Markdown.
    /// - Parameter options: `DownOptions` to modify parsing or rendering, defaulting to `.default`.
    /// - Returns: <#description#>
    public func toHTMLFromGFM(_ options: DownOptions = .default) throws -> String {
        let ast = try DownASTRenderer.stringToASTFromGFM(self, options: options)
        let html = try DownHTMLRenderer.astToHTMLFromGFM(ast.ast, extensions: ast.extensions, options: options)
        defer {
            cmark_parser_free(ast.parser)
            cmark_node_free(ast.ast)
        }
        return html
    }
}
