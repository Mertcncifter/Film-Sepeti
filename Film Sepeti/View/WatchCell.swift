//
//  WatchCell.swift
//  Film Sepeti
//
//  Created by mert can çifter on 10.05.2022.
//

import UIKit
import Foundation

class WatchCell: UITableViewCell {
    
    // MARK: - Properties
    
    
    var watch: Watch? {
        didSet { configure() }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.8
        label.setDimensions(width: UIScreen.main.bounds.width * 0.8, height: 50)
        return label
    }()
    
    private lazy var watchButton: UIButton = {
        let image = UIImage(systemName: "play.square.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        var iv = image?.renderResizedImage(newWidth: 35)
        let button = UIButton(type: .custom)
        button.setImage(iv, for: .normal)
        button.addTarget(self, action: #selector(handleUrl), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(watchButton)
        watchButton.anchor(right:rightAnchor, paddingRight: 10)
        nameLabel.anchor(left: leftAnchor, paddingLeft: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    // MARK: - Selectors
    
    @objc
    func handleUrl() {
        guard let link = watch?.link else { return }
        UIApplication.shared.open(URL(string: link)!)
    }
    
    
    
    // MARK: - Helpers
    
    func configure() {
        guard let watch = watch else { return }
        nameLabel.text = watch.name ?? "Unknown  name"
    }
    
    
    

}


