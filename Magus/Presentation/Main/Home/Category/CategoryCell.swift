//
//  CategoryCell.swift
//  Magus
//
//  Created by Jomz on 6/26/23.
//

import UIKit
import SDWebImage

class CategoryCell: HomeCustomCell {
    
    static let identifier = "CategoryCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var categoryImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.cornerRadius(with: 5)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(categoryImageView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupCell() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            categoryImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ])
    }
    
    override func configure(item: SectionViewModel.Item) {
        setTextWithShadow(text: item.title)
        categoryImageView.sd_setImage(with: item.imageUrl, placeholderImage: nil, context: nil) { [weak self] _, _, url in
            
        }
    }
    
    private func setTextWithShadow(text: String) {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let myAttribute = [NSAttributedString.Key.shadow: myShadow,
                           NSAttributedString.Key.font: UIFont.Montserrat.semibold1,
                           NSAttributedString.Key.foregroundColor: UIColor.white]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute)
        titleLabel.attributedText = myAttrString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView.image = nil
    }
    
}

extension CategoryCell {
    
    struct Model: ItemModel {
        var id: String
        var title: String
        var imageUrl: URL?
    }
}
