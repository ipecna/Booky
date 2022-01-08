//
//  WordCell.swift
//  Booky
//
//  Created by Semyon Chulkov on 09.10.2021.
//

import UIKit

class WordCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?
    
    private let padding: CGFloat = 8
    
    var wordLabel: UILabel = {
        var wordLabel = UILabel()
        wordLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        wordLabel.adjustsFontSizeToFitWidth = true
        wordLabel.allowsDefaultTighteningForTruncation = true
        return wordLabel
    }()
    var definitionLabel : UILabel = {
        var definititonLabel = UILabel()
        definititonLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return definititonLabel
    }()
    var synonymLabel: UILabel = {
        var synonymLabel = UILabel()
        synonymLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        return synonymLabel
    }()
    
    var exampleLabel: UILabel = {
        var exampleLabel = UILabel()
        exampleLabel.font = UIFont.italicSystemFont(ofSize: 17)
        return exampleLabel
    }()
    
    var antonymLabel: UILabel = {
        var antonymLabel = UILabel()
        antonymLabel.textColor = #colorLiteral(red: 0.703143537, green: 0.006636462174, blue: 0.1280881166, alpha: 1)
        antonymLabel.adjustsFontSizeToFitWidth = true
        antonymLabel.allowsDefaultTighteningForTruncation = true
        return antonymLabel
    }()
    
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
    //MARK: - Stacks
    
    private lazy var rootStack: UIStackView = {
        let rootStack = UIStackView(arrangedSubviews: [topStack, disclosureIndicator])
        rootStack.alignment = .top
        rootStack.axis = .horizontal
        rootStack.distribution = .fill
        
        return rootStack
    }()
    
    private lazy var topStack: UIStackView = {
        let topStack = UIStackView(arrangedSubviews: [wordLabel, colorStack, definitionLabel, exampleLabel])
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.alignment = .leading
        topStack.axis = .vertical
        topStack.distribution = .fill
        topStack.spacing = padding
        return topStack
    }()
    
    private lazy var colorStack: UIStackView = {
        let colorStack = UIStackView(arrangedSubviews: [antonymLabel, synonymLabel])
        colorStack.axis = .horizontal
        colorStack.spacing = padding
        colorStack.distribution = .equalSpacing
        return colorStack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        clipsToBounds = true
        contentView.backgroundColor = UIColor(named: "Foreground")

        contentView.addSubview(rootStack)
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        
        setUpConstraints()
        updateAppearance()
    }
    
    func updateAppearance() {
        closedConstraint?.isActive = !isSelected
        openConstraint?.isActive = isSelected
        
        UIView.animate(withDuration: 0.3) { // 0.3 seconds matches collection view animation
            // Set the rotation just under 180º so that it rotates back the same way
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            self.disclosureIndicator.transform = self.isSelected ? upsideDown :.identity
        }
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])

        // We need constraints that define the height of the cell when closed and when open
        // to allow for animating between the two states.
        closedConstraint =
            wordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        closedConstraint?.priority = .defaultLow // use low priority so stack stays pinned to top of cell

        openConstraint =
            exampleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        openConstraint?.priority = .defaultLow
    }
    
    func deleteCell() {
        
    }
    
}
