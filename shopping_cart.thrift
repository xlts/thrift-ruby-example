struct Category {
  1: string name,
  2: Category parent_category
}

struct Product {
  1: string name,
  2: i32 stock,
  3: Category category
}

struct OrderItem {
  1: Product product,
  2: i32 amount
}

struct Cart {
  1: list<OrderItem> order_items
}

exception AmountExceeded {
  1: string message
}

service CartService {
  list<Product> get_products(),
  list<OrderItem> show_cart(),
  bool add_item_to_cart(1:Product product, 2:i32 amount) throws (1:AmountExceeded amount_exceeded),
  bool delete_product(1:Product product),
  bool edit_amount(1:Product product, 2:i32 amount),
  bool check_out() throws (1:AmountExceeded amount_exceeded)
}