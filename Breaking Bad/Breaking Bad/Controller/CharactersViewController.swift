//
//  CharactersViewController.swift
//  Breaking Bad
//
//  Created by Mehmet Ali Kısacık on 30.09.2022.
//

import UIKit
import Kingfisher

class CharactersViewController: UIViewController {

    @IBOutlet weak var charactersCollectionView: UICollectionView! {
        didSet {
            charactersCollectionView.delegate = self
            charactersCollectionView.dataSource = self
            charactersCollectionView.register(UINib(nibName: String.init(describing: CharactersCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String.init(describing:  CharactersCollectionViewCell.self))
        }
    }

    @IBOutlet weak var characterSearchBar: UISearchBar!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var cancelSearchButtonWidth: NSLayoutConstraint!

    private var fetchCharactersDispatchGroup = DispatchGroup()
    private var tapOutside = UITapGestureRecognizer()
    private var allCharacters: Characters?
    private var filteredCharacters: Characters?
    private var isCharactersFiltered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacters()
        fetchCharactersDispatchGroup.notify(queue: .main) {
            self.charactersCollectionView.reloadData()
        }

        setupTapOutside()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerFetchCharacters), userInfo: nil, repeats: true)
    }

    private func fetchCharacters() {
        fetchCharactersDispatchGroup.enter()
        NetworkManager.shared.fetchCharacters { [weak self] results in
            switch results {
            case .success(let result):
                self?.allCharacters = result
            case .failure(let failure):
                print(failure.errorDescription ?? "")
            }
            self?.fetchCharactersDispatchGroup.leave()
        }
    }

    private func filterCharacters(searchText: String) {
        let filteredCharacters = allCharacters?.filter({ character in
            if character.name?.lowercased().contains(searchText.lowercased()) ?? false {
                return true
            } else {
                return false
            }
        })
        self.filteredCharacters = filteredCharacters
    }

    private func setupTapOutside() {
        tapOutside = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @IBAction func cancelSearchButtonClicked(_ sender: UIButton) {
        characterSearchBar.resignFirstResponder()
        characterSearchBar.text = ""
        cancelSearchButtonWidth.constant = 0
        UIView.animate(withDuration: 0.3,delay: 0,options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
        isCharactersFiltered = false
        charactersCollectionView.reloadData()
    }

    @objc func timerFetchCharacters() {
        fetchCharacters()
    }

    @objc private func dismissKeyboard() {
        characterSearchBar.resignFirstResponder()
    }

    @objc private func keyboardWillShow() {
        view.addGestureRecognizer(tapOutside)
    }

    @objc private func keyboardDidHide() {
        view.removeGestureRecognizer(tapOutside)
    }

}

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCharactersFiltered ? filteredCharacters?.count ?? 0 : allCharacters?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = charactersCollectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CharactersCollectionViewCell.self), for: indexPath) as? CharactersCollectionViewCell else {
            return UICollectionViewCell()
        }

        if isCharactersFiltered {
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
            isCharactersFiltered = true
            charactersCollectionView.reloadData()
        }

        cancelSearchButtonWidth.constant = 80
        UIView.animate(withDuration: 0.3,delay: 0,options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }

}
