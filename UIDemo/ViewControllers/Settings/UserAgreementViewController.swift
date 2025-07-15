import UIKit

class UserAgreementViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "用户协议"
        setupUI()
        setupRightBarButton()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "这里是用户协议页面。"
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
        let infoButton = UIBarButtonItem(title: "说明", style: .plain, target: self, action: #selector(infoTapped))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func infoTapped() {
        let alert = UIAlertController(title: "说明", message: "本协议仅供演示。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 