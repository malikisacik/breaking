//
//  ViewController.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var charactersCollectionView: UICollectionView! {
        didSet {
            charactersCollectionView.delegate = self
            charactersCollectionView.dataSource = self
            charactersCollectionView.register(UINib(nibName: String.init(describing: CharactersCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String.init(describing:  CharactersCollectionViewCell.self))
        }
    }

    private var characters: Characters?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacters()
    }

    private func fetchCharacters() {
        NetworkManager.shared.fetchCharacters { [weak self] results in
            switch results {
            case .success(let result):
                self?.characters = result
                self?.charactersCollectionView.reloadData()
                self?.filterCharacters(searchText: "Gus")
            case .failure(let failure):
                print(failure.errorDescription ?? "")
            }
        }
    }

    private func filterCharacters(searchText: String) {
        let filteredCharacters = characters?.filter({ character in
            if character.name?.contains(searchText) ?? false {
                return true
            } else {
                return false
            }
        })
        characters = filteredCharacters
        charactersCollectionView.reloadData()
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = charactersCollectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CharactersCollectionViewCell.self), for: indexPath) as? CharactersCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let characters = characters {
            cell.setup(character: characters[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 3, height: collectionView.frame.size.height/3 - 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }

}
