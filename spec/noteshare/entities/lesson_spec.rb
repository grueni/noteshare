require 'spec_helper'

include Noteshare::Core::Document
include OldNoteshare

describe Lesson do

  before do

    $VERBOOSE = true
    DocumentRepository.clear

  end


  it 'can create a Lesson with specified attributes' do

    lesson = LessonRepository.create Lesson.new(title: 'Momentum', author_id: 1, course_id: 1, sequence: 1)
    lesson.title.must_equal('Momentum')
    lesson.author_id.must_equal(1)
    lesson.course_id.must_equal(1)
    lesson.sequence.must_equal(1)

    lesson2 = LessonRepository.find lesson.id
    lesson2.title.must_equal(lesson.title)

  end

  it 'can create and persist corresponding document object' do
    UserRepository.clear
    user = User.create(first_name: 'John', last_name: 'Doe', screen_name: 'jd', password: 'foo12345', password_confirmation: 'foo12345')

    lesson = Lesson.new(title: 'Introductory Magick')
    lesson.created_at = DateTime.now
    lesson.updated_at = DateTime.now
    doc = lesson.to_document(user.screen_name)
    doc.title.must_equal lesson.title

    doc2 = DocumentRepository.find doc.id
    doc2.title.must_equal(doc.title)

  end


  # place your tests here
end
