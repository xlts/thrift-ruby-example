$:.push('gen-rb')
$:.unshift '../../lib/rb/lib'

require 'thrift'
require 'cart_service'

begin
  port = ARGV[0] || 9090

  transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost', port))
  protocol = Thrift::BinaryProtocol.new(transport)
  client = CartService::Client.new(protocol)

  transport.open()

  products = client.get_products

  puts "products: #{products}"


  products[0..1].each { |item| client.add_item_to_cart(item, 1) }

  puts "cart: #{client.show_cart}"

  client.check_out

  puts "cart: #{client.show_cart}"

  transport.close()

rescue Thrift::Exception => tx
  print 'Thrift::Exception: ', tx.message, "\n"
end
