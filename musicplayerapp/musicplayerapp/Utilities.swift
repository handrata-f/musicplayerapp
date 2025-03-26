//
//  Utilities.swift
//  musicplayerapp
//
//  Created by Handrata Febrianto on 26/03/25.
//

import Foundation
import UIKit
import Alamofire

extension String {
    func isEqualLowercased(_ other: String) -> Bool {
        return self.lowercased() == other.lowercased()
    }
}

extension UIAlertController {
    static func simpleShow(_ title: String?, _ message: String, _ stringBtn: String, handler: ((UIAlertAction) -> Swift.Void)? = nil, _ stringBtn2: String, handler2: ((UIAlertAction) -> Swift.Void)? = nil, _ targetDisplay: UIViewController? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if (stringBtn.count != 0) {
            let btn = UIAlertAction(title: stringBtn, style: .default, handler: handler)
            alert.addAction(btn)
        }
        if (stringBtn2.count != 0) {
            let btn = UIAlertAction(title: stringBtn2, style: .default, handler: handler2)
            alert.addAction(btn)
        }
        let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        let keyWindow = windowScene?.windows.first(where: { $0.isKeyWindow })
        var rootViewController = keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        if let presented = rootViewController?.presentedViewController {
            rootViewController = presented
        }
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let presented = rootViewController?.presentedViewController {
            rootViewController = presented
        }

        if let target = targetDisplay {
            rootViewController = target
        }

        rootViewController?.present(alert, animated: true, completion: nil)

    }

    static func simpleShow(_ title: String?, _ message: String, _ stringBtn: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        simpleShow(title, message, stringBtn, handler: handler, "", handler2: nil)
    }

    static func simpleShow(_ title: String?, _ message: String) {
        simpleShow(title, message, "OK")
    }
}

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}
