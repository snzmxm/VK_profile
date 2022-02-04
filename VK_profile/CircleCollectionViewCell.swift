//
//  CircleCollectionViewCell.swift
//  VK_profile
//
//  Created by SNZ on 02.02.2022.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CircleCollectionViewCell"

    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50/2
        imageView.backgroundColor = .orange
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = contentView.bounds
    }

    public func configure(with name: String) {
        myImageView.image = UIImage(named: name)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
}
