//
//  AddPlaylistViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/30/23.
//

import UIKit
import RxSwift
import RxDataSources

class AddPlaylistViewController: CommonViewController {
    
    private let viewModel = AddPlaylistViewModel()
    
    @IBOutlet var navigationBar: ProfileNavigationBar! {
        didSet {
            navigationBar.configure(
                model: ProfileNavigationBar.saveButtonModel(backHandler: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, saveHandler: { [weak self] in
                    self?.viewModel.addPlaylist()
                    // TODO: SAVE PLAYLIST
                }, title: "Save")
            )
        }
    }
    
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            coverImageView.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var playlistTitleForm: FormTextFieldView! {
        didSet {
            playlistTitleForm.configure(
                model: TextFieldView.Model(
                    placeholder: "Playlist Title",
                    textRelay: viewModel.playlistTitle
                )
            )
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }
    
    func configure(playlist: Playlist? = nil) {
        viewModel.playlistID = playlist?.playlistID
        viewModel.playlistTitle.accept(playlist?.title ?? "")
        tableView.isHidden = playlist == nil
        playlistTitleForm.isHidden = playlist != nil
    }
    
    private func setupDataSource() {
        viewModel.optionRelay.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PlaylistOptionCell.identifier, cellType: PlaylistOptionCell.self)) { (row, element, cell) in
                cell.configure(model: element)
            }
            .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                switch indexPath.row {
                case 0:
                    self?.tableView.isHidden = true
                    self?.playlistTitleForm.isHidden = false
                case 1:
                    // TODO: ADD TO FAVORITE
                    break
                case 2:
                    // TODO: DELETE PLAYLIST
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.backObservable
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.alertObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] model in
                self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
            }
            .disposed(by: disposeBag)
        
    }
    
}
