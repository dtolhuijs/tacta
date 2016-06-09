# tacta.rb
require 'json'

def read_contacts
   json = File.read( 'contacts.json' )
   array = JSON.parse( json, { :symbolize_names => true } )
end

def write_contacts( contacts )
   File.open( "contacts.json", "w" ) do |f|
      json = JSON.pretty_generate( contacts )
      f.write( json  )
   end
end

def index(contacts)
  contacts.each_with_index do |contact, i|
     puts "#{i+1}) #{contact[:name]}"
  end
end

def action_new( contacts )
   contact = create_new

   contacts << contact
   write_contacts(contacts)

   puts
   puts "New contact created:"
   puts

   show( contact )
   puts
end

def action_show( contacts, i )
   contact = contacts[i-1]

   puts
   show( contact )
   puts
end

def action_delete( contacts )
   puts
   response = ask "Delete which contact? "

   i = response.to_i

   puts
   puts "Contact for #{contacts[i-1][:name]} deleted."

   contacts.delete_at( i-1 )

   write_contacts(contacts)

   puts
end

def action_error
   puts
   puts "Sorry, I don't recognize that command."
   puts
end

def show(contact)
   puts "#{contact[:name]}"
   puts "phone: #{contact[:phone]}"
   puts "email: #{contact[:email]}"
end

def create_new
   contact = {}

   puts
   puts "Enter contact info:"

   contact[:name ] = ask "Name? "
   contact[:phone] = ask "Phone? "
   contact[:email] = ask "Email? "

   contact
end

def ask(prompt)
   puts
   print prompt
   gets.chomp
end

def contact_exists?(contacts, response)
  return false unless response =~ /[0-9]+/
  i = response.to_i
  !contacts[i-1].nil?
end

loop do
  contacts = read_contacts
  index( contacts )

  puts
  response = ask "Who would you like to see (n for new, d for delete, q to quit)? "

  break if response == "q"

  if response == "n"
    action_new( contacts )
  elsif response == "d"
    action_delete( contacts )
  elsif response =~ /[0-9]+/
    if contact_exists?(contacts, response)
      action_show( contacts, response.to_i )
    else
      puts
      puts "That contact does not exist!"
      puts
    end
  else
    action_error
  end
end
