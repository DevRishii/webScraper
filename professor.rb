# object for containing SEI on a professor
class Professor

    def initialize(instructor, course, campus, term, numberOfSEIs, averageRating)
        @instructor = instructor
        @course = course
        @campus = campus
        @term = term
        @numberOfSEIs = numberOfSEIs
        @averageRating = averageRating
    
    end

    def to_s
        "[#{@instructor}, #{@course}, #{@campus}, #{@term}, #{@numberOfSEIs}, #{@averageRating}]"
    end

end