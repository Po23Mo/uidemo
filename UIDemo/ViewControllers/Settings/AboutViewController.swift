import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "关于我们"
        setupUI()
        setupRightBarButton()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "APPStore\n版本 1.0\n版权所有 © 2024"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRightBarButton() {
        let infoButton = UIBarButtonItem(title: "演示", style: .plain, target: self, action: #selector(infoButtonTapped))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func infoButtonTapped() {
        let alert = UIAlertController(title: "演示", message: "这是右上角按钮的演示。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 