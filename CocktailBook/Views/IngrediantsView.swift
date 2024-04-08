//
//  IngrediantsView.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 06/04/24.
//

import UIKit

class IngrediantsView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrowtriangle.right.fill")) // Replace "arrow_icon" with your image name
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.label
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.label.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ text: String) {
        label.text = text
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(label)

        // Add constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),

            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 5),
            label.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),

        ])
    }
}
