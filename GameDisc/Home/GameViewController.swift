import UIKit
import swift_vibrant

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Propriedades
    
    private let featureGameView = FeatureGameView()
    private let networkManager = NetworkManager.shared
    
    private let genresList = [12, 8, 14, 15, 9]
    
    private let featuredGame: Game = Game(id: 1009, name: "The Last of Us", ratingCount: 91, screenshots: [236], genres: [0])
    
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
        table.isScrollEnabled = false
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
        loadLovedGames()
        // generateLists()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = logoView
        featureGameView.translatesAutoresizingMaskIntoConstraints = false
        featureGameView.configure(with: featuredGame)
        tableView.dataSource = self
        tableView.delegate = self
        featureGameView.delegate = self
    }
    
    private func addViewsToHierarchy() {
        view.addSubview(featureGameView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            featureGameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            featureGameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            featureGameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            featureGameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            featureGameView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: featureGameView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadLovedGames() {
      networkManager.fetchGamesLoved(amount: 12) { result in
        switch result {
        
        case .success(let games):
          let collectionViewModel = CollectionTableViewCellViewModel(categoryTitle: "Os favoritos da comunidade <3", games: games)
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
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
            fatalError()
        }
        

        cell.configure(with: viewModel)
        cell.delegate = self
        
        print(viewModel)
        
        return cell
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
    func didTapCell() {
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail")
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// Generate Lists
extension GameViewController {
    func generateLists() {
        for genreId in genresList {
            networkManager.fetchGamesByGenre(amount: 2, genreId: genreId) { result in
                switch result {
                
                case .success(let games):
                  let collectionViewModel = CollectionTableViewCellViewModel(categoryTitle: "Os favoritos da comunidade <3", games: games)
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
        }

}
