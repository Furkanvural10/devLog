import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FirebaseManagerProtocol {
//    func createAnonymousUser(completion: @escaping ((Result<User, NetworkError>) -> Void))
    func getData<T: Codable>(completion: @escaping ((Result<T, NetworkError>) -> Void))
}


final class FirebaseManager: FirebaseManagerProtocol {

    static let shared = FirebaseManager()
    private var userID = ""
    private var database = Firestore.firestore()
    
    private init() {}
    
    func createAnonymousUser(completion: @escaping (Result<User, NetworkError>) -> Void) {
        
        Auth.auth().signInAnonymously { result, error in
            guard error == nil else {
                completion(.failure(.authError))
                return
            }
            guard let result = result else {
                completion(.failure(.authResultError))
                return
            }
            
            let user = User(userID: result.user.uid)
            self.userID = result.user.uid
            completion(.success(user))
        }
    }
    
    func getTask<T: Codable>(taskType: TaskType, projectName: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        database.collection("users").document(id).collection("Project").document(projectName).collection(taskType.rawValue).getDocuments { snapshot, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            for document in snapshot.documents {
                do {
                    let product = try document.data(as: T.self)
                    completion(.success(product))
                }
                catch {
                    print("decode error")
                    return
                }
            }
        }
    }
    
    func getData<T: Codable>(completion: @escaping ((Result<T, NetworkError>) -> Void)) {
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        let database = Firestore.firestore()
        database.collection("daily").document("D3KZECwR6lIAnUN8TXaC").collection("Daily").addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Data error")
                completion(.failure(.dataError))
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot error")
                completion(.failure(.snapshotError))
                return
            }
            var products = [T]()
            for document in snapshot.documents {
                do {
                    let product = try document.data(as: T.self)
                    products.append(product)
                    completion(.success(product))
                }
                catch {
                    print("decode error")
                    completion(.failure(.decodeError))
                    return
                }
            }
        }
    }
}

