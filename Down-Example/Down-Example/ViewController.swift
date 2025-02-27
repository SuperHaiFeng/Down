//
//  ViewController.swift
//  Down-Example
//
//  Created by Keaton Burleson on 7/1/17.
//  Copyright © 2016-2019 Down. All rights reserved.
//

import UIKit
import Down
import libcmark

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderDownInWebView()
    }
    
}

private extension ViewController {
    
    func renderDownInWebView() {
//        guard let readMeURL = Bundle.main.url(forResource: nil, withExtension: "md"),
//              let readMeContents = try? String(contentsOf: readMeURL)
//            else {
//                showError(message: "Could not load readme contents.")
//                return
//        }
        
        let readMeContents = "## 总结\n- **`scrollHeight`问题**：`scrollHeight` 不包含 `margin`，可以使用 `padding` 代替。\n- **`scrollView` 设置**：重置`contentInset`，确保内容高度计算准确。\n- **HTML 结构**：重置所有元素的边距和内边距。\n-**手动调整高度**：在获取高度后，手动添加下方间距。\n- **使用 `offsetHeight`**：`offsetHeight` 包含`padding`，更适合计算内容高度。\n通过以上方法，你可以确保获取的高度包含下方的间距。如果问题仍然存在，请检查 HTML 结构和 `WKWebView` 的默认样式。\n- [ ] 完成项目文档初稿\n- [x] 参加团队会议\n- [ ] 与客户沟通需求\n### 表格\n\n| Header 1 | Header 2 | Header 2 | Header 2 |\n|----------|----------|----------|----------|\n| Cell 1   | Cell 2   | Cell 2   | Cell 2   |\n```swift\nprivate func removeTrailingNewline(attr: NSAttributedString) -> NSAttributedString {\n    let length = attr.length\n    if length > 0 {\n        let lastCharRange = NSRange(location: length - 1, length: 1)\n        let lastChar = (attr.string as NSString).substring(with: lastCharRange)\n        if lastChar == \"\\n\" {\n            let newRange = NSRange(location: 0, length: length - 1)\n            let newArrt = attr.attributedSubstring(from: newRange)\n            return newArrt\n        }\n    }\n    return attr\n}\n```\n这是一段 ~~带有删除线~~ 的文本。\n这是一段包含 <script>alert('危险代码')</script> 的 Markdown 文本。\n访问 https://www.example.com 获取更多信息\n#### 结束"
        do {
            let downView = try DownView(frame: view.bounds, markdownString: readMeContents, didLoadSuccessfully: {
                print("Markdown was rendered.")
            })
            downView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(downView)
            constrain(subview: downView)
            createStatusBarBackgrounds(above: downView)
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    func createStatusBarBackgrounds(above subview: UIView) {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurEffectView, aboveSubview: subview)
        constrain(subview: blurEffectView, bottomAnchor: topLayoutGuide.bottomAnchor)
    }
    
    func constrain(subview: UIView, bottomAnchor: NSLayoutYAxisAnchor? = nil) {
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor ?? bottomLayoutGuide.bottomAnchor)
        ])
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "DownView Render Error",
                                                message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
