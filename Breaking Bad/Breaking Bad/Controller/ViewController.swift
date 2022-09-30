//
//  ViewController.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var charactersCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCharacters()
    }

    private func fetchCharacters() {
        NetworkManager.shared.fetchCharacters { results in
            switch results {
            case .success(let result):
                print(result)
            case .failure(let failure):
                print(failure.errorDescription ?? "")
            }
        }
    }

}

