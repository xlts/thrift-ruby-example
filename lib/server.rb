$:.push('gen-rb')
$:.unshift '../../lib/rb/lib'

require 'thrift'
require 'cart_service'

class CartServiceHandler

  def initialize
    @order_items = []
    categories = 2.times.map { |i| Category.new(name: "category#{i}") }
    @products = [Product.new(name: "prod1", stock: 5, category: categories[0]),
                 Product.new(name: "prod2", stock: 5, category: categories[1]),
                 Product.new(name: "prod3", stock: 4, category: categories[0])]
  end

  def get_products
    @products
  end

  def show_cart
    @order_items
  end

  def add_item_to_cart(product, amount)
    raise AmountExceeded.new if product.stock - amount < 0
    @order_items << OrderItem.new(product: product, amount: amount) if find_order_item(product)
  end

  def delete_product(product)
    item = find_order_item(product)
    @order_items.delete(item) if item
  end

  def edit_amount(product, amount)
    item = find_order_item(product)
    item.amount = amount if item
  end

  def check_out
    @order_items.each do |item|
      raise AmountExceeded.new if item.product.stock - item.amount < 0
      item.product.stock = item.product.stock - item.amount
    end
    @order_items = []
  end

private

  def find_order_item(product)
    @order_items.find { |item| item.product == product }
  end
end

handler = CartServiceHandler.new
processor = CartService::Processor.new(handler)
transport = Thrift::ServerSocket.new(9090)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(processor, transport, transportFactory)

puts "Starting the server..."
server.serve()
puts "done."
