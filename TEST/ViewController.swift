//
//  ViewController.swift
//  TEST
//
//  Created by Elizabeth Serykh on 20.01.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var persons: [Person] = []
    
    let tableView: UITableView = {
        let tw = UITableView()
        tw.isScrollEnabled = true
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllCharacters { result in
            switch result {
            case .success(let data):
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print(jsonString)
//                }
                do {
                    let decoder = JSONDecoder()
                    let charactersData = try decoder.decode(PersonData.self, from: data)
                    self.persons = charactersData.results
                           
                           DispatchQueue.main.async {
                               self.tableView.reloadData()
                           }
                       } catch {
                           print("Error decoding characters data: \(error)")
                       }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        ])
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
 

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let person = persons[indexPath.row]

        cell.namePerson.text = person.name


        if let imageUrl = URL(string: person.image) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.imagePerson.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }

        let status = URL(string: person.status)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedPerson = persons[indexPath.row]
        let status = selectedPerson.status
        let statusVC = StatusViewController()
        if status == "Alive" {
            statusVC.statusColor = UIColor.green
        } else if status == "Dead" {
            statusVC.statusColor = UIColor.red
        } else {
            statusVC.statusColor = UIColor.white
        }
        statusVC.status = status

        navigationController?.pushViewController(statusVC, animated: true)
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

