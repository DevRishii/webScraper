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

    #returns instructor name
    def instructor
        @instructor
    end

    #returns course name
    def course
        @course
    end

    #returns term name
    def term
        @term
    end

    #returns numberOfSEIs name
    def numberOfSEIs
        @numberOfSEIs
    end

    #returns averageRating name
    def averageRating
        @averageRating
    end
    
    def to_s
        "[#{@instructor}, #{@course}, #{@campus}, #{@term}, #{@numberOfSEIs}, #{@averageRating}]"
    end

end