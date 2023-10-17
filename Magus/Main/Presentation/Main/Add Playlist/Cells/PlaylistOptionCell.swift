//
//  PlaylistOptionCell.swift
//  Magus
//
//  Created by Jose Mari Pascual on 10/1/23.
//

import UIKit

class PlaylistOptionCell: UITableViewCell {
    
    @IBOutlet var optionLabel: UILabel!
    
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleView()
    }
    
    private func styleView() {
        backgroundColor = .clear
        optionLabel.font = .Montserrat.bold15
        iconImageView.contentMode = .scaleAspectFit
        cornerRadius(with: 5)
    }
    
    func configure(model: Model) {
        iconImageView.image = UIImage(named: model.icon)
        optionLabel.text = model.label
    }
    
    private func updateColor() {
        let isSelected = isSelected || isHighlighted
        let backgroundColor = isSelected ? UIColor.Background.primaryBlue.withAlphaComponent(0.11) : .clear
        contentView.backgroundColor = backgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateColor()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateColor()
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
}

extension PlaylistOptionCell {
    
    struct Model {
        let icon: ImageAsset
        let label: String
    }
    
    static let options: [Model] = [
        Model(icon: .edit, label: "Rename Playlist"),
        Model(icon: .favorite, label: "Add to Favorites"),
        Model(icon: .trash, label: "Delete Playlist")
    ]
    
    static let activeOptions: [Model] = [
        Model(icon: .edit, label: "Rename Playlist"),
        Model(icon: .favoriteIsActive, label: "Remove to Favorites"),
        Model(icon: .trash, label: "Delete Playlist")
    ]
}
