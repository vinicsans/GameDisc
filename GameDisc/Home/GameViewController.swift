import UIKit
import swift_vibrant

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Propriedades
    
    private let featureGameView = FeatureGameView()
    private let networkManager = NetworkManager.shared
    
    private let featuredGame: Game = Game(
        id: 1, name: "The Last of Us", ratingCount: 0, screenshots: [], genres: [1]
    )
    
    private var viewModels: [CollectionTableViewCellViewModel] = [
        CollectionTableViewCellViewModel(categoryTitle: "Test", games: [
            Game(id: 0, name: "Hello", ratingCount: 9, screenshots: [], genres: [])
        ])
    ]
    
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
        scrollView.addSubview(featureGameView)
        scrollView.addSubview(tableView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            featureGameView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            featureGameView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            featureGameView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            featureGameView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            featureGameView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: featureGameView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModels.count) * (view.frame.size.width/2)),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func loadLovedGames() {
      print("loadLovedGames() called")
      networkManager.fetchGamesLoved(amount: 10) { result in
        switch result {
        
        case .success(let games):
          let collectionViewModel = CollectionTableViewCellViewModel(categoryTitle: "API Request", games: games)
          self.viewModels.append(collectionViewModel)
        
            DispatchQueue.main.async { [self] in

                tableView.reloadData()
          }
        
        case .failure(_):
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
        let viewController = soryboard.instantiateViewController(withIdentifier: "Detail")
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
