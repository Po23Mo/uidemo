import UIKit

class FavoriteCell: UITableViewCell {
    
    // MARK: - UI Components
    private let appImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        // App Image
        appImageView.contentMode = .scaleAspectFit
        appImageView.layer.cornerRadius = 8
        appImageView.clipsToBounds = true
        appImageView.backgroundColor = .systemGray6
        contentView.addSubview(appImageView)
        
        // Name Label
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.numberOfLines = 2
        contentView.addSubview(nameLabel)
        
        // Date Label
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray
        contentView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            appImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appImageView.widthAnchor.constraint(equalToConstant: 50),
            appImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            dateLabel.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }
    
    func configure(with favorite: Favorite) {
        nameLabel.text = favorite.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: favorite.addedDate)
        
        // 加载图片
        if let imageURL = URL(string: favorite.iconURL) {
            loadImage(from: imageURL, into: appImageView)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
} 