import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // App Detail Tab
        let appDetailVC = AppDetailViewController()
        let appDetailNav = UINavigationController(rootViewController: appDetailVC)
        appDetailNav.tabBarItem = UITabBarItem(
            title: "详情",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")
        )
        
        // Settings Tab
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "设置",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        // Favorites Tab
        let favoritesVC = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "收藏",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        // Messages Tab
        let messagesVC = MessagesViewController()
        let messagesNav = UINavigationController(rootViewController: messagesVC)
        messagesNav.tabBarItem = UITabBarItem(
            title: "消息",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message.fill")
        )
        
        // Profile Tab
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "我的",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [appDetailNav, settingsNav, favoritesNav, messagesNav, profileNav]
        
        // Tab Bar Style
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }
} 
