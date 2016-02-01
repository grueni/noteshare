require 'concurrent'
require 'date'

class PrimeWorker

  def is_prime?(num)
    return false if (2...num).any?{ |i| num % i == 0 }
    true
  end

  def get_prime_at(pos)
    count = 0
    num = 2
    loop do
      count += 1 if is_prime?(num)
      break if count == pos
      num += 1
    end
    num
  end

end

start_time = Time.now

futures = []
futures << Concurrent::Future.execute{ PrimeWorker.new.get_prime_at(4000) }
futures << Concurrent::Future.execute{ PrimeWorker.new.get_prime_at(4000) }
futures << Concurrent::Future.execute{ PrimeWorker.new.get_prime_at(4000) }
futures << Concurrent::Future.execute{ PrimeWorker.new.get_prime_at(4000) }

while (futures.any? {|p| p.state != :fulfilled})
  sleep 2
  puts "waiting..."
end

puts futures.map(&:value)
puts "Elapsed: #{Time.now - start_time} seconds"
