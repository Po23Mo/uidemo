import UIKit

class FavoritesViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var favorites: [Favorite] = []
    private var filteredFavorites: [Favorite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "收藏"
        
        searchBar.placeholder = "搜索收藏的应用"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFavorites() {
        favorites = DatabaseService.shared.getAllFavorites()
        filteredFavorites = favorites
        tableView.reloadData()
    }
    
    private func filterFavorites(with query: String) {
        if query.isEmpty {
            filteredFavorites = favorites
        } else {
            filteredFavorites = favorites.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let favorite = filteredFavorites[indexPath.row]
        cell.configure(with: favorite)
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite = filteredFavorites[indexPath.row]
        let detailVC = FavoriteDetailViewController()
        detailVC.favorite = favorite
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = filteredFavorites[indexPath.row]
            
            if DatabaseService.shared.deleteFavorite(id: favorite.id) {
                filteredFavorites.remove(at: indexPath.row)
                if let index = favorites.firstIndex(where: { $0.id == favorite.id }) {
                    favorites.remove(at: index)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterFavorites(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filterFavorites(with: "")
    }
} 
