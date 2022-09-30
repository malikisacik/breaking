//
//  NetworkManager.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import Foundation
import Alamofire

final class NetworkManager {

    static let shared = NetworkManager()

    private var components = URLComponents() {
        didSet{
            components.scheme = "https"
            components.host = NetworkConstants.apiHostString
        }
    }

    func fetchCharacters (completion: @escaping (Result<Characters,AFError>) -> Void ) {
        components.path = "/api/characters"

        if let urlString = components.string {
            AF.request(urlString, method: .get).responseDecodable(of: Characters.self) { response in
                completion(response.result)
            }
        }
    }

}

