require 'pry'
def consolidate_cart(cart)
  final_hash = {}
  cart.each do |element_hash|
    element_name = element_hash.keys[0]
    element_stats = element_hash.values[0]

    if final_hash.has_key?(element_name)
      final_hash[element_name][:count] += 1
    else
      final_hash[element_name] = {
        count: 1,
        price: element_stats[:price],
        clearance: element_stats[:clearance]
      }
    end
end
final_hash
end

def apply_coupons(cart:[], coupons:[])
  # code here	  coupons.each do |coupon|
    coupon_name = coupon[:item]
    coupon_item_num = coupon[:num]
    cart_item = cart[coupon_name]

    next if cart_item.nil? || cart_item[:count] < coupon_item_num

    cart_item[:count] -= coupon_item_num

    coupon_in_cart = cart["#{coupon_name} W/COUPON"]

    if coupon_in_cart
      coupon_in_cart[:count] += 1
    else
      cart["#{coupon_name} W/COUPON"] = {
        price: coupon[:cost],
        clearance: cart_item[:clearance],
        count: 1
      }
    end
  end

  cart
end



def apply_clearance(cart)
  cart.each do |product_name, stats|
    stats[:price] -= stats[:price] * 0.2 if stats[:clearance]
  end
  cart
end

def checkout(array, coupons)
  hash_cart = consolidate_cart(array)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) { |acc, key, value| acc += value[:price] * value[:count] }
  total > 100 ? total * 0.9 : total
end
