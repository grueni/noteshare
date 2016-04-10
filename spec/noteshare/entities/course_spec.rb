require 'spec_helper'

include Noteshare::Core

describe Course do


  before do

    $VERBOOSE = true
    DocumentRepository.clear
    LessonRepository.clear
    CourseRepository.clear

    @lesson1 = LessonRepository.create Lesson.new(title: 'Force', author_id: 1, sequence: 1)
    @lesson2 = LessonRepository.create Lesson.new(title: 'Momentum', author_id: 1, sequence: 2)
    @lesson3 = LessonRepository.create Lesson.new(title: 'Energy', author_id: 1, sequence: 3)
    @course = CourseRepository.create Course.new(title: 'Physics', author_id: 1)

    @lesson1.course_id = @course.id
    @lesson2.course_id = @course.id
    @lesson3.course_id = @course.id

    @lesson1.content = "== Force\n\nLet it always be with you.\n"
    @lesson2.content = "== Momentum\n\nIt keeps moving that which is in motion.\n"
    @lesson3.content = "== Energy\n\nIt is what makes stuff heppen.\n"

    LessonRepository.update @lesson1
    LessonRepository.update @lesson2
    LessonRepository.update @lesson3

    UserRepository.clear
    @user = User.create(first_name: 'John', last_name: 'Doe', screen_name: 'jd', password: 'foo12345', password_confirmation: 'foo12345')


  end

  it 'can create and persist a course object' do

    @course.title.must_equal('Physics')
    @course2 = CourseRepository.find @course.id
    @course2.title.must_equal('Physics')

  end

  it 'can create and persist corresponding document object' do

    course = Course.new(title: 'Introductory Magick')
    course.created_at = DateTime.now
    course.updated_at = DateTime.now
    doc = course.to_document @user.screen_name
    doc.title.must_equal course.title

    doc2 = DocumentRepository.find doc.id
    doc2.title.must_equal(doc.title)

  end


  it 'can associate lessons to a course'  do

    lessons = @course.associated_lessons
    lessons.all.count.must_equal(3)
    lessons.first.title.must_equal(@lesson1.title)

  end

  it 'can create a master document (doc + sections) from a course' do

    master = @course.create_master_document @user.screen_name

    master.title.must_equal(@course.title)

    master.subdocument(0).title.must_equal(@lesson1.title)
    master.subdocument(1).title.must_equal(@lesson2.title)
    master.subdocument(2).title.must_equal(@lesson3.title)
    master.subdocument(0).next_document.title.must_equal(@lesson2.title)
    # Fixme:
    master.subdocument(1).previous_document.title.must_equal(@lesson1.title)

    table = TOC.new(master).table
    table[0].title.must_equal(@lesson1.title)
    table[1].title.must_equal(@lesson2.title)
    table[2].title.must_equal(@lesson3.title)

  end


  # place your tests here
end
