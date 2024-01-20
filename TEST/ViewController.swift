//
//  ViewController.swift
//  TEST
//
//  Created by Elizabeth Serykh on 20.01.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var persons: [Person] = []
    
    let tableView: UITableView = {
        let tw = UITableView()
        tw.backgroundColor = .cyan
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllCharacters { result in
            switch result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            //tableView.widthAnchor.constraint(equalToConstant: 500),
            //tableView.heightAnchor.constraint(equalToConstant: 1000)
        ])
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
 

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let person = persons[indexPath.row]

        cell.namePerson.text = person.name


        if let imageUrl = URL(string: person.image),
           let imageData = try? Data(contentsOf: imageUrl) {
            cell.imagePerson.image = UIImage(data: imageData)
        }

        return cell
    }
    

    func getAllCharacters(completion: @escaping (Result<Data, Error>) -> Void) {
        // URL для запроса
        let apiUrl = URL(string: "https://rickandmortyapi.com/api/character/")!

        let session = URLSession.shared

        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let error = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }

            if let data = data {
                completion(.success(data))
            }
        }

        tableView.reloadData()
        task.resume()
    }



    
}

