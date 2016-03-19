require 'fileutils'
require 'active_record'
require 'csv'

# Using Active Record with an index for O(1) time for contact lookups.

class Contact < ActiveRecord::Base
end  


# ContactManager module. 

module ContactManager  
  
  def self.setup
    ActiveRecord::Base.establish_connection("adapter" => "sqlite3","database"  => "./db/development.sqlite3")
    import_contacts if ARGV[0] == 'setup'
  end  

  def self.startup_message
    "\n\nWelcome to Contact Manager. Usage examples:\n\n'contacts S', To list by last name\n'contacts email AnEmail@gmail.com', To search by email\n\n"
  end  

  def self.could_not_understand_request_message
    "\n\nI'm sorry, your command was not understood. Usage examples:\n\n'contacts S', To list by last name\n'contacts email AnEmail@gmail.com', To search by email\n\n"
  end  

  def self.import_contacts
    Contact.destroy_all
    CSV.foreach("./csv/contacts.csv",:headers => true) do |contacts|  
      Contact.create(first_name: contacts[0],last_name: contacts[1],email: contacts[2],phone: contacts[3])
    end
  end  

  def self.list_contacts_by_last_name(starting_with_letter)
    contacts = Contact.find_by_sql("SELECT * FROM contacts WHERE last_name LIKE '#{starting_with_letter}%' ORDER BY last_name")
    if contacts.any?
      contacts.each do |contact|
        puts "\nLast: #{contact.last_name}, First: #{contact.first_name}, Phone: #{contact.phone}, E-Mail: #{contact.email}"
      end  
    else
      puts "\nThere are no contacts starting with #{starting_with_letter}"  
    end  
    puts "\n\n"
  end 

  def self.find_contact_by_email(email)
    contacts = Contact.where(email: email)
    if contacts.any?
      contacts.each do |contact|
        puts "\nLast: #{contact.last_name}, First: #{contact.first_name}, Phone: #{contact.phone}, E-Mail: #{contact.email}"
      end  
    else
      puts "\nThere are no contacts starting with email #{email}"  
    end  
    puts "\n\n"
  end 

end # ContactManager




# Set up and run loop


ContactManager.setup   
ContactManager.startup_message
contact_manager_command = 'start'

while (contact_manager_command != 'exit') do
  
  puts "\n\nContact Manager v 0.0.1"
  command_line = STDIN.gets.chomp.split
  contact_manager_command, args = command_line[0],command_line[1..command_line.size]

  if contact_manager_command =~ /contacts/i && args.size == 1 && args[0].size == 1
    ContactManager.list_contacts_by_last_name(args[0])
  elsif contact_manager_command =~ /contacts/i && args.size == 2 && args[0] =~ /email/i 
    ContactManager.find_contact_by_email(args[1])
  elsif contact_manager_command != 'exit'
    puts ContactManager.could_not_understand_request_message  
  end  

end
