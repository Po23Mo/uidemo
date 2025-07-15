import UIKit
import WebKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var settings = Setting.defaultSettings
    private let themes = ["Light", "Dark", "Auto"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "设置"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "settings"),
           let savedSettings = try? JSONDecoder().decode(Setting.self, from: data) {
            settings = savedSettings
        }
    }
    
    private func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "settings")
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 3
        case 2: return 5
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.configure(title: "夜间模式", type: .switch, value: settings.isDarkMode) { [weak self] value in
                    if let boolValue = value as? Bool {
                        self?.settings.isDarkMode = boolValue
                        self?.saveSettings()
                    }
                }
            case 1:
                cell.configure(title: "字体大小", type: .slider, value: settings.fontSize, minValue: 14, maxValue: 28) { [weak self] value in
                    if let floatValue = value as? Float {
                        self?.settings.fontSize = floatValue
                        self?.saveSettings()
                    }
                }
            case 2:
                cell.configure(title: "缓存天数", type: .stepper, value: settings.cacheDays, minValue: 1, maxValue: 30) { [weak self] value in
                    if let intValue = value as? Int {
                        self?.settings.cacheDays = intValue
                        self?.saveSettings()
                    }
                }
            default:
                break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                cell.configure(title: "用户名", type: .textField, value: settings.username) { [weak self] value in
                    if let stringValue = value as? String {
                        self?.settings.username = stringValue
                        self?.saveSettings()
                    }
                }
            case 1:
                cell.configure(title: "生日", type: .datePicker, value: settings.birthday) { [weak self] value in
                    if let dateValue = value as? Date {
                        self?.settings.birthday = dateValue
                        self?.saveSettings()
                    }
                }
            case 2:
                cell.configure(title: "主题", type: .picker, value: settings.theme, options: themes) { [weak self] value in
                    if let stringValue = value as? String {
                        self?.settings.theme = stringValue
                        self?.saveSettings()
                    }
                }
            default:
                break
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                cell.configure(title: "清除缓存", type: .button) { [weak self] _ in
                    self?.clearCache()
                }
            case 1:
                cell.configure(title: "隐私政策", type: .button) { [weak self] _ in
                    self?.showPrivacyPolicy()
                }
            case 2:
                cell.configure(title: "关于我们", type: .button) { [weak self] _ in
                    self?.showAboutUs()
                }
            case 3:
                cell.configure(title: "帮助中心", type: .button) { [weak self] _ in
                    self?.showHelpCenter()
                }
            case 4:
                cell.configure(title: "用户协议", type: .button) { [weak self] _ in
                    self?.showUserAgreement()
                }
            default:
                break
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "外观"
        case 1: return "通用"
        case 2: return "关于"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "设置自动保存于 UserDefaults"
        }
        return nil
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingsViewController {
    private func clearCache() {
        let alert = UIAlertController(title: "清除缓存", message: "确定要清除所有缓存数据吗？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .destructive) { [weak self] _ in
            self?.performClearCache()
        })
        
        present(alert, animated: true)
    }
    
    private func performClearCache() {
        let progressAlert = UIAlertController(title: "清除缓存", message: "正在清除...", preferredStyle: .alert)
        present(progressAlert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            progressAlert.dismiss(animated: true) {
                DatabaseService.shared.clearAllFavorites()
                
                let successAlert = UIAlertController(title: "完成", message: "缓存清除成功", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "确定", style: .default))
                self.present(successAlert, animated: true)
            }
        }
    }
    
    private func showPrivacyPolicy() {
        let webVC = WebViewController()
        webVC.url = URL(string: "https://example.com/privacy")
        webVC.title = "隐私政策"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func showAboutUs() {
        let aboutVC = AboutViewController()
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    private func showHelpCenter() {
        let helpVC = HelpCenterViewController()
        navigationController?.pushViewController(helpVC, animated: true)
    }
    private func showUserAgreement() {
        let userVC = UserAgreementViewController()
        navigationController?.pushViewController(userVC, animated: true)
    }
}

class WebViewController: UIViewController {
    var url: URL?
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadURL() {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            let html = """
            <html>
            <head>
                <title>隐私政策</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body { font-family: -apple-system; padding: 20px; line-height: 1.6; }
                    h1 { color: #007AFF; }
                </style>
            </head>
            <body>
                <h1>隐私政策</h1>
                <p>这是应用的隐私政策页面。我们承诺保护您的隐私安全。</p>
                <p>本应用不会收集任何个人敏感信息，所有数据都存储在您的设备本地。</p>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
} 
