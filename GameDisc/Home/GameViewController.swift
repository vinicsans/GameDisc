import UIKit
import swift_vibrant

enum Row {
    case banner(Game)
    case carousel(String, [Game])
}

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Propriedades

    private let networkManager = NetworkManager.shared
    private var viewModels: [CollectionTableViewCellViewModel] = []
    private var rows: [Row] = []
    
    private lazy var logoView: UIImageView = {
        let logoImage = UIImage(named: "Logo")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return imageView
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.register(FeatureGameViewCell.self, forCellReuseIdentifier: FeatureGameViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.allowsSelection = false
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        configureViews()
        addViewsToHierarchy()
        setupConstraints()
     
        loadLists()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = logoView
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addViewsToHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        
        switch row {
        case let .banner(game):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeatureGameViewCell.identifier, for: indexPath) as? FeatureGameViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.setGame(game)
            return cell
        case let .carousel(title, games):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
                fatalError()
            }
            let viewModel = CollectionTableViewCellViewModel(categoryTitle: title, games: games)
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/2
    }
}

extension GameViewController: FeatureGameViewCellDelegate, CollectionTableViewCellDelegate {
    func didTapGame(game: Game) {
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        viewController.game = game
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Load Lists

extension GameViewController {
    
    private func loadLists() {
        let genresList = [12, 8, 14, 15, 9]
        loadingView.startAnimating()
        loadLovedGames { [weak self] in
            self?.loadGenreLists(genresList: genresList)
        }
    }
        
    private func loadGenreLists(genresList: [Int]) {
        for genre in genresList {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.loadGenreName(genreId: genre) { genreName in
                    self?.networkManager.fetchGenreList(genreId: genre) { result in
                        switch result {
                        case .success(let games):
                            self?.rows.append(.carousel(genreName, games))
                            DispatchQueue.main.async {
                                self?.loadingView.stopAnimating()
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    private func loadGenreName(genreId: Int, completion: @escaping (String) -> Void) {
        networkManager.fetchGenreName(genreId: genreId) { result in
            switch result {
            case .success(let genreArray):
                let genreName = genreArray[0].name
                completion(genreName)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadLovedGames(completion: @escaping () -> Void) {
        networkManager.fetchLovedGames() { result in
            switch result {
            case .success(let games):
                self.rows.append(.banner(games[0]))
                self.rows.append(.carousel("Os favoritos pela comunidade <3", games))
            case .failure(let error):
                print(error)
                fatalError()
            }
            completion()
        }
    }
}
