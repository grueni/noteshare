module Noteshare
  module Display

    def display(label, args)

      puts
      puts label.red
      args.each do |field|
        begin
          puts "#{field.to_s}: #{self.send(field)}"
        rescue
          puts "#{field.to_s}: ERROR".red
        end
      end
      puts

    end


  end
end