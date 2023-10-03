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
    private var loadingVC: UIViewController?
    
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
    
    @IBOutlet var playlistTitleForm: FormTextFieldView!
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        playlistTitleForm.configure(
            model: TextFieldView.Model(
                placeholder: "Playlist Title",
                textRelay: viewModel.playlistTitle
            )
        )
    }
    
    func configure(playlist: Playlist? = nil) {
        viewModel.playlist = playlist
        viewModel.playlistTitle.accept(playlist?.title ?? "")
        tableView.isHidden = playlist == nil
        playlistTitleForm.isHidden = playlist != nil
        playlistTitleForm.configure(
            model: TextFieldView.Model(
                placeholder: "Playlist Title",
                textRelay: viewModel.playlistTitle
            )
        )
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
                    self?.viewModel.toggleFavorite()
                case 2:
                    self?.presentDeleteAlert()
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
                if self?.loadingVC == nil {
                    self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                } else {
                    self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoadingObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] condition in
                if condition && self?.loadingVC != nil {
                    self?.loadingVC = self?.presentLoading()
                } else if !condition {
                    self?.loadingVC?.dismiss(animated: false, completion: {
                        self?.loadingVC = nil
                    })
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func presentDeleteAlert() {
        let alertVC = DefaultAlertViewController.instantiate(from: .defaultAlert) as! DefaultAlertViewController
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true)
        alertVC.configure(.init(title: "", message: "Are you sure you want to delete this Playlist?", image: .delete, actionHandler: { [weak self] in
            self?.dismiss(animated: true)
            self?.viewModel.deletePlaylist()
        }))
    }
    
}
