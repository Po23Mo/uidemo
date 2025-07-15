import UIKit

class HelpCenterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "帮助中心"
        setupUI()
        setupRightBarButton()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "这里是帮助中心页面。"
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
        let contactButton = UIBarButtonItem(title: "联系客服", style: .plain, target: self, action: #selector(contactTapped))
        navigationItem.rightBarButtonItem = contactButton
    }
    
    @objc private func contactTapped() {
        let alert = UIAlertController(title: "联系客服", message: "请拨打 400-123-4567", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 