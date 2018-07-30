require 'net/http'
require 'twilio-ruby'
require 'date'
require 'time'


class TellMe

	def initialize
		@symbols = ["siri", "syf", "brk.b"]
		@@symbols = []
# Necessary class variable to track a percentage change -->
	 	@@openprice = opentrack("siri")
	end

	def checktime
		
		loop do
			current_time = Time.now.strftime("%H:%M")
			first_start = "08:45"

				if current_time >= first_start
				pricelookup
					break
  				end
		end
track_fucntion_1 = <<-BOM
		loop do
			current_time = Time.now.strftime("%H:%M")
			track_time = "10:25"
				if current_time == track_time 
					pricetracking("siri")
					break
				end
		end
BOM
		loop do
			current_time = Time.now.strftime("%H:%M")
			second_start = "10:45"

				if current_time >= second_start
					pricelookup
					break
  				end
		end
		
track_fucntion_2 = <<-BOM
		loop do
			current_time = Time.now.strftime("%H:%M")
			track_time = "14:30"
				if current_time == track_time 
					pricetracking("siri")
					break
				end
		end
BOM

track_function_3 = <<-BOM
		loop do
			current_time = Time.now.strftime("%H:%M")
			track_time = "18:16"
				if current_time == track_time 
					pricetracking("siri")
					break
				end
		end
	BOM
		loop do
			current_time = Time.now.strftime("%H:%M")
			third_start = "12:00"

				if current_time >= third_start
					pricelookup
					break
  				end
		end
		loop do 
			second_time = Time.now.strftime("%H:%M")
			fourth_start = "14:30"

				if second_time >= fourth_start
					pricelookup
					break
				end
		end
		loop do 
			second_time = Time.now.strftime("%H:%M")
			fifth_start = "16:00"

				if second_time >= fifth_start
					pricelookup
					break
				end
		end
	end

	def opentrack(opener)

		@opener = opener
		uri = URI('http://www.nasdaq.com/symbol/' + @opener.to_s + '/real-time')
				@quote = Net::HTTP.get(uri)
			stock_price = @quote.scan(/\W\W\W\d+\.\d+/i)
			number = stock_price[0]
			final_quote = number.delete('"\">$')
			puts "The program open price is #{final_quote}"
			return final_quote
	end	

	def pricetracking(lookup)

			@lookup = lookup
			uri = URI('http://www.nasdaq.com/symbol/' + @lookup.to_s + '/real-time')
				@quote = Net::HTTP.get(uri)
			stock_price = @quote.scan(/\W\W\W\d+\.\d+/i)
			number = stock_price[0]
			final_quote = number.delete('"\">$')
		#print prices to screen and begin messaging method
			analytics(final_quote)

	end

	def pricelookup

		@symbols.each do |stock|

			uri = URI('http://www.nasdaq.com/symbol/' + stock.to_s + '/real-time')
				@quote = Net::HTTP.get(uri)
			stock_price = @quote.scan(/\W\W\W\d+\.\d+/i)
			number = stock_price[0]
			final_quote = number.delete('"\">$')
		#print prices to screen and begin messaging method
			puts final_quote
			textprices(stock, final_quote)
		end
	end

	def textprices(stock, final_quote)

		@stock = stock
		@final_quote = final_quote
		message = "#{stock} is currently trading at #{@final_quote}"

		account_sid = ENV["account_sid"] 
		auth_token = ENV["auth_token"]
			
		@client = Twilio::REST::Client.new account_sid, auth_token
	
		message = @client.account.messages.create(
									:body =>  message,
									:to => ENV["myNum"],
									:from => ENV["twilioNum"])
			puts message.sid
	end

	def analytics(tracked_price_movements)

		@@symbols << tracked_price_movements.to_f

		case @@symbols.length
		when 2
			@@symbols.map do |currentprice|
				puts "Calculating percentage increase/decrease between the opening price of:#{@@openprice} and #{currentprice}..."
				percent_increase = ( ( currentprice.to_f - @@openprice.to_f ) / @@openprice.to_f ) * 100
				puts "The current price increase at this time is #{percent_increase} percent."
			end
		else
			checktime
		end
	end
end

checker = TellMe.new
checker.checktime