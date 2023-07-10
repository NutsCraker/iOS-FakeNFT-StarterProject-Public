
import UIKit

enum AlertMaker {
    static func make(
        title: String,
        message: String,
        repeatHandle: @escaping () -> Void,
        cancelHandle: (() -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            repeatHandle()
        }

        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            cancelHandle?()
        }

        alertController.addAction(repeatAction)
        alertController.addAction(cancelAction)

        return alertController
    }
}
