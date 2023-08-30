import UIKit
import swift_vibrant

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Propriedades
    
    private let featureGameView = FeatureGameView()
    private let networkManager = NetworkManager.shared
    
    private let genresList = [12]
    
    private var viewModels: [CollectionTableViewCellViewModel] = []
    
    private lazy var logoView: UIImageView = {
        let logoImage = UIImage(named: "Logo")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.allowsSelection = false
        table.separatorStyle = .none
        table.register(FeatureGameView.self, forCellReuseIdentifier: "FeatureGameCell")
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
    
        for i in genresList {
            loadGenresList(id: i)
        }
     
        loadLovedGames()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = logoView
        featureGameView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        featureGameView.delegate = self
    }
    
    private func addViewsToHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadGenresList(id: Int) {
        networkManager.fetchGenreList(genreId: id) { result in
            switch result {
            case .success(let games):
                print(games)
                let collectionViewModel = CollectionTableViewCellViewModel(categoryTitle: "placeholder", games: games)
                self.viewModels.append(collectionViewModel)
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    
    func loadLovedGames() {
        networkManager.fetchLovedGames() { result in
            switch result {
            case .success(let games):
                print(games)
                let collectionViewModel = CollectionTableViewCellViewModel(categoryTitle: "Os favoritos pela comunidade <3", games: games)
                self.viewModels.append(collectionViewModel)
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count + 1 // +1 for the featured game cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureGameCell", for: indexPath) as! FeatureGameView
            cell.delegate = self
            //.configure(with: featuredGame)
            return cell
        } else {
            let viewModel = viewModels[indexPath.row - 1]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/2
    }
    
    
}

extension GameViewController: FeatureGameViewDelegate {
    func didTapCard() {
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "Detail")
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension GameViewController: CollectionTableViewCellDelegate {
    func didTapCell(at indexPath: IndexPath){
        let selectedGame = viewModels[indexPath.row].games[indexPath.item]
        print(indexPath.section)
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {
            return
        }
        print(viewModels.count)
        print(indexPath)
        detailViewController.game = selectedGame
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
