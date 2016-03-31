

require_relative '../entities/ns_document'


# Seed data for the database for NSDocument
  module Noteshare::Setup

    def self.seed_db

      SettingsRepository.clear
      UserRepository.clear
      DocumentRepository.clear

      @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
      SettingsRepository.create(Settings.new(owner: @user.full_name))


      @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author: current_user_full_name))
      @section1 = DocumentRepository.create(NSDocument.new(title: 'Uncertainty Principle', author: current_user_full_name, subdoc_refs: []))
      @section2 = DocumentRepository.create(NSDocument.new(title: 'Wave-Particle Duality', author: current_user_full_name, subdoc_refs: []))
      @section3 = DocumentRepository.create(NSDocument.new(title: 'Matrix Mechanics', author: current_user_full_name, subdoc_refs: []))
      @subsection =  DocumentRepository.create(NSDocument.new(title: "de Broglie's idea", author: current_user_full_name, subdoc_refs: []))
      @subsubsection =  DocumentRepository.create(NSDocument.new(title: "Einstein's view", author: current_user_full_name, subdoc_refs: []))


      @article.content = "= Quantum Mechanics\n\n:numbered:\nQuantum phenomena are weird!"
      @section1.content = "== Uncertainty Principle\n\nThe Uncertainty Principle invalidates the notion of trajectory"
      @section2.content = "== Wave-Particule Duality\n\nIt is, like, _so_ weird!"
      @section3.content = "== Matrix Mechanic\n\nIts all about the eigenvalues"
      @subsection.content = "=== de Broglie's idea\n\nHe was a count, and he firmly maintained that $a^2 + b^2 = c^2$"
      @subsection.content << "\n[env.theorem]\n--\nThere are infinitely many primes\n--\n\n"
      @subsubsection.content = "==== Einstein's view\n\nGod does not play with dice."

      @article.render_options[:format] = 'adoc-latex'
      @section1.render_options[:format] = 'adoc-latex'
      @section1.render_options[:format] = 'adoc-latex'
      @section2.render_options[:format] = 'adoc-latex'
      @section3.render_options[:format] = 'adoc-latex'
      @subsection.render_options[:format] = 'adoc-latex'
      @subsection.render_options[:format] = 'adoc-latex'
      @subsubsection.render_options[:format] = 'adoc-latex'

      DocumentRepository.update @article
      DocumentRepository.update @section1
      DocumentRepository.update @section2
      DocumentRepository.update @section3
      DocumentRepository.update @subsection
      DocumentRepository.update @subsubsection

      @section1.insert(0,@article)
      @section2.insert(1,@article)
      @section3.insert(2,@article)

      DocumentManager.new(@section2).append(@subsection)
      DocumentManager.new(@subsection).append(@subsubsection)

      DocumentRepository.all.each do |document|
        # document.update_table_of_contents
        # document.update_content
        # document.compile_with_render
      end

      DocumentRepository.all.count

  end


end