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
        view.contentMode = .scaleAspectFill
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
        initialiseGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(categoryImageView)
        containerView.addSubview(titleLabel)
    }
    
    private func initialiseGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        containerView.addGestureRecognizer(tap)
        containerView.isUserInteractionEnabled = true
    }
    
    @objc private func tapHandler() {
        tapActionHandler?()
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
    
    var tapActionHandler: CompletionHandler?
    
    override func configure(item: SectionViewModel.Item) {
        
        setTextWithShadow(text: item.title)
        categoryImageView.sd_setImage(with: item.imageUrl, placeholderImage: .init(named: .coverImage), context: nil) { [weak self] _, _, url in
            
        }
        tapActionHandler = item.tapActionHandler
        if let item = item as? CategoryCell.Model {
            containerView.cornerBorderRadius(cornerRadius: 5, borderColor: item.isSelected ? UIColor.Background.primaryBlue : UIColor.clear, borderWidth: 5)
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
        var tapActionHandler: CompletionHandler?
        let isSelected: Bool
        
        init(id: String, title: String, imageUrl: URL? = nil, isSelected: Bool, tapActionHandler: CompletionHandler? = nil) {
            self.id = id
            self.title = title
            self.imageUrl = imageUrl
            self.tapActionHandler = tapActionHandler
            self.isSelected = isSelected
        }
    }
}
