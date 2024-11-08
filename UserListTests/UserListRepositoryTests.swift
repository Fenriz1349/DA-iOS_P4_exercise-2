import XCTest
@testable import UserList

final class UserListRepositoryTests: XCTestCase {
    // Happy path test case
    func testFetchUsersSuccess() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        
        // When
        let users = try await repository.fetchUsers(quantity: quantity)
        
        // Then
        XCTAssertEqual(users.count, quantity)
        XCTAssertEqual(users[0].name.first, "John")
        XCTAssertEqual(users[0].name.last, "Doe")
        XCTAssertEqual(users[0].dob.age, 31)
        XCTAssertEqual(users[0].picture.large, "https://example.com/large.jpg")
        
        XCTAssertEqual(users[1].name.first, "Jane")
        XCTAssertEqual(users[1].name.last, "Smith")
        XCTAssertEqual(users[1].dob.age, 26)
        XCTAssertEqual(users[1].picture.medium, "https://example.com/medium.jpg")
    }
    
    // Unhappy path test case: Invalid JSON response
    func testFetchUsersInvalidJSONResponse() async throws {
        // Given
        let invalidJSONData = "invalid JSON".data(using: .utf8)!
        let invalidJSONResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let mockExecuteDataRequest: (URLRequest) async throws -> (Data, URLResponse) = { _ in
            return (invalidJSONData, invalidJSONResponse)
        }
        
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        
        // When
        do {
            _ = try await repository.fetchUsers(quantity: 2)
            XCTFail("Response should fail")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testShouldLoadMoreData_returnFalse() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        let sut = UserListViewModel(repository: repository)
        sut.users = try await repository.fetchUsers(quantity: quantity)
        // When
        let isNotLastItem = sut.shouldLoadMoreData(currentItem: sut.users.first!)
        // Then
        XCTAssertEqual(isNotLastItem, false)
    }
    
    func testShouldLoadMoreData_returnTrue() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        let sut = UserListViewModel(repository: repository)
        sut.users = try await repository.fetchUsers(quantity: quantity)
        // When
        let isLastItem = sut.shouldLoadMoreData(currentItem: sut.users.last!)
        // Then
        XCTAssertEqual(isLastItem, true)
    }
    
    func testShouldLoadMoreData_emptyUserList_returnsFalse() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let users = try await repository.fetchUsers(quantity: 2)
        // When - leave sut.users empty
        let result = sut.shouldLoadMoreData(currentItem: users.first!)
        // Then
        XCTAssertFalse(result, "Expected shouldLoadMoreData to return false when users list is empty")
    }
    
    func testReloadUsers() async {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)

        // When: appeler `reloadUsers`
        await sut.reloadUsers()
        // Then: vérifier que `users` a bien été vidé puis rechargé
        XCTAssertEqual(sut.users.count, 2, "Expected `users` to be reloaded with 2 new users")
        XCTAssertEqual(sut.users.first?.name.first, "John", "Expected first user to be `John` after reload")
        
        // Vérifier que `isLoading` est correctement géré
        XCTAssertFalse(sut.isLoading, "Expected `isLoading` to be false after reload completes")
    }
    
    func testBornOnString_isNotFrench() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        let sut = UserListViewModel(repository: repository)
        sut.users = try await repository.fetchUsers(quantity: quantity)
        // When
        sut.isFrench = false
        let bornOnReturnString = sut.bornOnString(for: sut.users.first!)
        // Then
        XCTAssertEqual(bornOnReturnString,"born on :")
    }
    
    func testBornOnString_isFrenchAndMonsieur() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        let sut = UserListViewModel(repository: repository)
        sut.users = try await repository.fetchUsers(quantity: quantity)
        // When
        sut.isFrench = true
        let bornOnReturnString = sut.bornOnString(for: sut.users.first!)
        // Then
        XCTAssertEqual(bornOnReturnString,"né le :")
    }
    
    func testBornOnString_isFrenchAndMadame() async throws {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        sut.users = try await repository.fetchUsers(quantity: 2)
        // When
        sut.isFrench = true
        let bornOnReturnString = sut.bornOnString(for: sut.users.last!)
        // Then
        XCTAssertEqual(bornOnReturnString,"née le :")
    }
    
    func testGetFrenchDate_isNotValid(){
        // Given
        let dob = User.Dob(date: "wrong", age: 10)
        // When
        let dobInFrench = dob.getFrenchDate()
        // Then
        XCTAssertEqual(dobInFrench,"wrong")
    }
    
    func testGetFrenchDate_isValid(){
        // Given
        let dob = User.Dob(date: "1990-12-12T21:31:56.618Z", age: 10)
        // When
        let dobInFrench = dob.getFrenchDate()
        // Then
        XCTAssertEqual(dobInFrench,"12 décembre 1990")
    }
    
    func testGetUSDate_isNotValid(){
        // Given
        let dob = User.Dob(date: "wrong", age: 10)
        // When
        let dobInFrench = dob.getUSDate()
        // Then
        XCTAssertEqual(dobInFrench,"wrong")
    }
    
    func testGetUSDate_isValid(){
        // Given
        let dob = User.Dob(date: "1990-12-12T21:31:56.618Z", age: 10)
        // When
        let dobInFrench = dob.getUSDate()
        // Then
        XCTAssertEqual(dobInFrench,"December 12 1990")
    }
}

private extension UserListRepositoryTests {
    // Define a mock for executeDataRequest that returns predefined data
    func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
}
