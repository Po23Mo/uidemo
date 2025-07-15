import UIKit

class FavoriteDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let appImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let idLabel = UILabel()
    
    var favorite: Favorite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "收藏详情"
        
        // ScrollView
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // App Image
        appImageView.contentMode = .scaleAspectFit
        appImageView.layer.cornerRadius = 20
        appImageView.clipsToBounds = true
        appImageView.backgroundColor = .systemGray6
        contentView.addSubview(appImageView)
        
        // Labels
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.textColor = .systemGray
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        idLabel.font = .systemFont(ofSize: 14)
        idLabel.textColor = .systemGray2
        idLabel.textAlignment = .center
        contentView.addSubview(idLabel)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // App Image
            appImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            appImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appImageView.widthAnchor.constraint(equalToConstant: 200),
            appImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: appImageView.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ID Label
            idLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func updateUI() {
        guard let favorite = favorite else { return }
        
        nameLabel.text = favorite.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = "收藏时间: \(dateFormatter.string(from: favorite.addedDate))"
        
        idLabel.text = "应用ID: \(favorite.id)"
        
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
