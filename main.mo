import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Bool "mo:base/Bool";
import Option "mo:base/Option";

actor {

  type BookId = Nat32;
  type Book = {
    title : Text;
    author : Text;
    genre : Text;
    isRead : Bool;
  };

  type ResponseBook = {
    title : Text;
    author : Text;
    genre : Text;
    isRead : Bool;
    id : Nat32;
  };

  private stable var nextBookId : BookId = 0;

  private stable var books : Trie.Trie<BookId, Book> = Trie.empty();

  public func addBook(book : Book) : async Text {
    let bookId = nextBookId;
    nextBookId += 1;
    books := Trie.replace(
      books,
      key(bookId),
      Nat32.equal,
      ?book,
    ).0;
    return ("Book Added Successfully");
  };

  public func updateBook(bookId : BookId, book : Book) : async Bool {
    let result = Trie.find(books, key(bookId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      books := Trie.replace(
        books,
        key(bookId),
        Nat32.equal,
        ?book,
      ).0;
    };
    return exists;
  };

  public func deleteBook(bookId : BookId) : async Bool {
    let result = Trie.find(books, key(bookId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      books := Trie.replace(
        books,
        key(bookId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  public func getBooks(id : BookId) : async ? Book {
      let result = Trie.find(books, key(id), Nat32.equal);
      return result;
  };

  private func key(x : BookId) : Trie.Key<BookId> {
    return { hash = x; key = x };
  };

};