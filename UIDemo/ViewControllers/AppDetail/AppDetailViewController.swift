import UIKit
import WebKit

class AppDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let appImageView = UIImageView()
    private let pageControl = UIPageControl()
    private let nameLabel = UILabel()
    private let versionLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let progressView = UIProgressView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let segmentedControl = UISegmentedControl(items: ["评价", "截图", "评论"])
    private let tableView = UITableView()
    private let downloadButton = UIButton(type: .system)
    
    private var app: App?
    private var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        fetchAppData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "App 详情"
        
        // ScrollView
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        // App Image
        appImageView.contentMode = .scaleAspectFit
        appImageView.layer.cornerRadius = 20
        appImageView.clipsToBounds = true
        appImageView.backgroundColor = .systemGray6
        contentView.addSubview(appImageView)
        
        // Page Control
        pageControl.numberOfPages = 5
        pageControl.currentPage = 3
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.currentPageIndicatorTintColor = .systemBlue
        contentView.addSubview(pageControl)
        
        // Labels
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        
        contentView.addSubview(nameLabel)
        
        versionLabel.font = .systemFont(ofSize: 16)
        versionLabel.textColor = .systemGray
        versionLabel.textAlignment = .center
        
        contentView.addSubview(versionLabel)
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        contentView.addSubview(descriptionLabel)
        
        // Progress View
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        
        contentView.addSubview(progressView)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = false
        
        contentView.addSubview(activityIndicator)
        
        // Segmented Control
        segmentedControl.selectedSegmentIndex = 1
        
        contentView.addSubview(segmentedControl)
        
        // Download Button
        downloadButton.setTitle("下载", for: .normal)
        downloadButton.backgroundColor = .systemBlue
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.layer.cornerRadius = 8
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(downloadButton)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = true
        
        contentView.addSubview(tableView)
        
        // Gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        appImageView.addGestureRecognizer(longPressGesture)
        appImageView.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
            appImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            appImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appImageView.widthAnchor.constraint(equalToConstant: 290),
            appImageView.heightAnchor.constraint(equalToConstant: 290),
            
            // Page Control
            pageControl.topAnchor.constraint(equalTo: appImageView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Version Label
            versionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            versionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            versionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Progress View
            progressView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Activity Indicator
            activityIndicator.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Download Button
            downloadButton.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Segmented Control
            segmentedControl.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // TableView
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func fetchAppData() {
        NetworkService.shared.fetchAppDetail { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let app):
                    self?.app = app
                    self?.updateUI(with: app)
                case .failure(let error):
                    print("Error fetching app data: \(error)")
                    self?.loadMockData()
                }
            }
        }
    }
    
    private func loadMockData() {
        let mockApp = App(
            id: 1,
            name: "极简天气",
            version: "1.0.0",
            description: "一款极简风格的天气应用，提供准确的天气预报和实时天气信息。界面简洁美观，功能实用。",
            iconURL: "https://via.placeholder.com/290x290/007AFF/FFFFFF?text=Weather",
            screens: [
                "https://via.placeholder.com/290x290/FF9500/FFFFFF?text=Screen1",
                "https://via.placeholder.com/290x290/FF2D92/FFFFFF?text=Screen2",
                "https://via.placeholder.com/290x290/5856D6/FFFFFF?text=Screen3"
            ],
            website: "https://example.com",
            rating: 4.5,
            reviews: [
                App.Review(author: "用户1", rating: 5, comment: "非常好用的天气应用", date: "2024-01-01"),
                App.Review(author: "用户2", rating: 4, comment: "界面简洁，功能齐全", date: "2024-01-02"),
                App.Review(author: "用户3", rating: 5, comment: "推荐使用", date: "2024-01-03")
            ]
        )
        updateUI(with: mockApp)
    }
    
    private func updateUI(with app: App) {
        nameLabel.text = app.name
        versionLabel.text = "版本 \(app.version)"
        descriptionLabel.text = app.description
        
        if let firstImageURL = URL(string: app.iconURL) {
            loadImage(from: firstImageURL, into: appImageView)
        }
        
        tableView.reloadData()
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
    
    @objc private func downloadButtonTapped() {
        activityIndicator.startAnimating()
        progressView.progress = 0.0
        
        var progress: Float = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.02
            self.progressView.progress = progress
            
            if progress >= 1.0 {
                timer.invalidate()
                self.activityIndicator.stopAnimating()
                self.progressView.progress = 1.0
                
                if let app = self.app {
                    let favorite = Favorite(id: app.id, name: app.name, iconURL: app.iconURL, addedDate: Date())
                    DatabaseService.shared.addFavorite(favorite)
                }
            }
        }
    }
    
    @objc private func handleLongPress() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "保存图片", style: .default) { _ in
            if let image = self.appImageView.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "分享", style: .default) { _ in

        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("保存图片失败: \(error)")
        } else {
            print("图片保存成功")
        }
    }
}

extension AppDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app?.reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let review = app?.reviews?[indexPath.row] {
            cell.textLabel?.text = "\(review.author) - \(review.comment)"
            cell.detailTextLabel?.text = "评分: \(review.rating)/5"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
} 
