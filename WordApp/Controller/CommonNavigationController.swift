import UIKit

class CommonNavigationController: UINavigationController {
    
    private let navigationBarView: UINavigationBar = {
        let nav = CustomNavigationBar(frame: .zero)
        // Configure navigation bar...
        return nav
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBarView.delegate = self
        let navBar = navigationBarView
        view.addSubview(navBar)

        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        // Do any additional setup after loading the view.
    }
}

extension CommonNavigationController: UINavigationBarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
