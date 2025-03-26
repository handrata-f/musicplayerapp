//
//  APIManager.swift
//  musicplayerapp
//
//  Created by Handrata Febrianto on 26/03/25.
//

import Foundation
import UIKit
import Alamofire

class APIManager: NSObject {
    static let shared = APIManager() // Singleton instance
    private let baseURL = "https://itunes.apple.com/"
    static var loadingIndicator: UIActivityIndicatorView?

    private override init() {} // Private init to prevent new instances

    static private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    static func showLoading(_ message: String? = nil) {
        guard let window = getKeyWindow() else { return }

        if loadingIndicator == nil {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = window.center
            spinner.color = .gray
            spinner.startAnimating()
            loadingIndicator = spinner
        }
        window.addSubview(loadingIndicator!)
    }

    static func hideLoading() {
        loadingIndicator?.removeFromSuperview()
    }

    // MARK: - Generic Request Function
    func requestAPI(endpoint: String,
                    method: HTTPMethod,
                    parameters: [String: Any]? = nil,
                    headers: HTTPHeaders? = nil,
                    completion: @escaping ([String: Any]) -> Void) {
        print("Request : \(endpoint)")
        AF.request(endpoint, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any] {
                        print("Response: \(json)")
                        completion(json)  // Return raw JSON response
                    } else {
                        APIManager.hideLoading()
                        print("Invalid JSON format")
                    }
                case .failure(let error):
                    APIManager.hideLoading()
                    print("\(error.errorDescription ?? "Unknown error")")
                }
            }
    }

    func getSearchMusic(_ keyword: String, completion: @escaping ([String: Any]) -> Void) {
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(baseURL)search?term=\(encodedKeyword)&entity=musicTrack&attribute=artistTerm&limit=25"
        requestAPI(endpoint: url, method: .get, completion: completion)
    }
}

