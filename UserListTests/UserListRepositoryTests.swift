import XCTest
@testable import UserList

final class UserListRepositoryTests: XCTestCase {
    
    // MARK: - UserListRepositary Tests
    // Happy path test case
    func testFetchUsers_Success() async throws {
        // Given
        let sut = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let quantity = 2
        
        // When
        let users = try await sut.fetchUsers(quantity: quantity)
        
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
    
    func testFetchUsers_invalidUrl_throwsError() async throws {
        // Given
        let sut = UserListRepository()
        let quantity = 2
        
        // When
        let invalidURL = ""
        
        // Then
        do {
            _ = try await sut.fetchUsers(quantity: quantity, url: invalidURL)
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL, "Expected URLError with code .badURL but got \(error.code)")
        }
    }
    
    // MARK: - UserListViewModel Tests
    // Unhappy path test case: Invalid JSON response
    @MainActor
    func testFetchUsers_invalidJSONResponse() async throws {
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
        
        let sut = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        
        // When
        do {
            _ = try await sut.fetchUsers(quantity: 2)
            XCTFail("Response should fail")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
    @MainActor
    func testFetchUsers_catchErrorShowsErrorMessage() async {
        // Given
        let errorMock: (URLRequest) async throws -> (Data, URLResponse) = { _ in
                    throw URLError(.cannotFindHost) // Simule une erreur réseau
                }
        let repository = UserListRepository(executeDataRequest: errorMock)
        let sut = UserListViewModel(repository: repository)
        
        // When
        await sut.fetchUsers()
        
        // Then
        XCTAssertTrue(sut.showError, "Expected showError to be true when an error occurs in fetchUsers.")
        XCTAssertEqual(sut.errorMessage, "Error fetching users: The operation couldn’t be completed. (NSURLErrorDomain error -1003.)")
    }
    
    @MainActor
    func testShowErrorMessage() {
        // Given
        let sut = UserListViewModel(repository: UserListRepository())
        let testErrorMessage = "An error occurred"
        
        // When
        sut.showErrorMessage(testErrorMessage)
        
        // Then
        XCTAssertEqual(sut.errorMessage, testErrorMessage, "Expected errorMessage to be set to the test message.")
        XCTAssertTrue(sut.showError, "Expected showError to be true after calling showErrorMessage.")
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
    
    func testNavigationTitle() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        
        // When
        sut.isFrench = true
        
        // Then
        XCTAssertEqual(sut.navigationTitle, "Utilisateurs")
        
        // When
        sut.isFrench = false
        
        // Then
        XCTAssertEqual(sut.navigationTitle, "Users")
    }
    
    func testDateOfBirthString() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        
        // Then
        XCTAssertEqual(sut.dateOfBirthString(for: sampleUser),"1 janvier 1990")
        
        // When
        sut.isFrench = false
        
        // Then
        XCTAssertEqual(sut.dateOfBirthString(for: sampleUser),"January 1 1990")
    }
    
    func testPreviewViewModel() async throws {
        // Given
        let viewModel = UserListViewModel.previewViewModel
        
        // Then
        XCTAssertNotNil(viewModel)
        
        // Given
        let userListResponse = UserListViewModel.userListResponsePreview
        
        // Then
        XCTAssertNotNil(userListResponse)
        
        // Given
        let user = UserListViewModel.userPreview
        
        // Then
        XCTAssertNotNil(user)
    }
    
    func testGetCivility_withTitleM() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "m", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Monsieur")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mister")
    }
    
    func testGetCivility_withTitleMonsieur() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "monsieur", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Monsieur")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mister")
    }

    func testGetCivility_withTitleMr() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "mr", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Monsieur")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mister")
    }
    
    func testGetCivility_withTitleMister() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "mister", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Monsieur")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mister")
    }

    func testGetCivility_withTitleMs() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "ms", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Madame")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mrs")
    }

    func testGetCivility_withTitleMrs() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "mrs", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Madame")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mrs")
    }
    
    func testGetCivility_withTitleMadame() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "madame", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Madame")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mrs")
    }

    func testGetCivility_withTitleMiss() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "miss", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mademoiselle")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Miss")
    }

    func testGetCivility_withTitleMademoiselle() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "mademoiselle", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mademoiselle")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Miss")
    }

    func testGetCivility_withTitleMlle() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "mlle", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Mademoiselle")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "Miss")
    }

    func testGetCivility_withUnknownTitle() {
        // Given
        let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        let sut = UserListViewModel(repository: repository)
        let sampleUserResponse = UserListResponse.User(
            name: UserListResponse.User.Name(title: "unknown", first: "John", last: "Doe"),
            dob: UserListResponse.User.Dob(date: "1990-01-01T21:31:56.618Z", age: 31),
            picture: UserListResponse.User.Picture(large: "", medium: "", thumbnail: "")
        )
        let sampleUser = User(user: sampleUserResponse)
        sut.users.append(sampleUser)
        
        // When
        sut.isFrench = true
        var civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "unknown")
        
        // When
        sut.isFrench = false
        civility = sut.getCivility(for: sut.users.first!)
        
        // Then
        XCTAssertEqual(civility, "unknown")
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
