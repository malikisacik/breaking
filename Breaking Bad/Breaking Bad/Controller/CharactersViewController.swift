//
//  CharactersViewController.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import UIKit
import Kingfisher

class CharactersViewController: UIViewController {

    @IBOutlet weak var characterSearchBar: UISearchBar!
    @IBOutlet weak var charactersCollectionView: UICollectionView! {
        didSet {
            charactersCollectionView.delegate = self
            charactersCollectionView.dataSource = self
            charactersCollectionView.register(UINib(nibName: String.init(describing: CharactersCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String.init(describing:  CharactersCollectionViewCell.self))
        }
    }

    private var allCharacters: Characters?
    private var filteredCharacters: Characters?
    private var isFiltered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacters()
        charactersCollectionView.reloadData()
    }

    private func fetchCharacters() {
        NetworkManager.shared.fetchCharacters { [weak self] results in
            switch results {
            case .success(let result):
                self?.allCharacters = result
                self?.charactersCollectionView.reloadData()
            case .failure(let failure):
                print(failure.errorDescription ?? "")
            }
        }
    }

    private func filterCharacters(searchText: String) {
        let filteredCharacters = allCharacters?.filter({ character in
            if character.name?.contains(searchText) ?? false {
                return true
            } else {
                return false
            }
        })
        self.filteredCharacters = filteredCharacters
    }

}

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltered ? filteredCharacters?.count ?? 0 : allCharacters?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = charactersCollectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CharactersCollectionViewCell.self), for: indexPath) as? CharactersCollectionViewCell else {
            return UICollectionViewCell()
        }

        if isFiltered {
            if let characters = filteredCharacters {
                cell.setup(character: characters[indexPath.row])
            }
        } else {
            if let characters = allCharacters {
                cell.setup(character: characters[indexPath.row])
            }
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

extension CharactersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            filterCharacters(searchText: searchText)
            isFiltered = true
            charactersCollectionView.reloadData()
        }
    }

}
