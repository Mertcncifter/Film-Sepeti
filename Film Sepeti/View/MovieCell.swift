//
//  MovieCell.swift
//  Film Sepeti
//
//  Created by mert can çifter on 4.05.2022.
//

import UIKit
import SDWebImage
import SkeletonView

class MovieCell: UITableViewCell {
    
    // MARK: - Properties
    
    var movie: Movie? {
        didSet { configure() }
    }
    
    private let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.isSkeletonable = true
        iv.setDimensions(width: 60, height: 60)
        return iv
    }()
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(movieLabel)
        contentView.addSubview(movieImageView)
        movieImageView.anchor(left: leftAnchor,paddingLeft: 10)
        movieLabel.centerY(inView: movieImageView)
        movieLabel.anchor(left: movieImageView.rightAnchor,paddingLeft: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Selector
    
    
    // MARK: - Helpers
    
    func configure() {
        guard let movie = movie else { return }
        guard let path = movie.poster_path else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else { return }
        movieImageView.sd_setImage(with: url)
        movieLabel.text = (movie.original_title ?? movie.original_name) ?? "Unknown title name"
    }
    
}
