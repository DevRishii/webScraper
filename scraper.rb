require "selenium-webdriver"

# logic for getting SEI
class Scraper inherits Selenium::WebDriver


    def initialize(name = "", campus = COL, dpt = cse, course = "")
    
        @name = name
        @campus = campus
        @dpt = dpt
        @course = course
    end

    # Asks the user for the name of the instructor and passes that into the appropriate field
    # Does not return anything
    def instructor(driver)
        puts "Please enter the name of the instructor in the following format(i.e. LastName, FirstName):"
        name = gets.chomp # gets instructor name from user 
        driver.find_element(:id, "txtInstructor").send_keys(name)
    end

    # Asks the user for the name of the campus and passes that into the appropriate field
    # Does not return anything
    def campus(driver)

    end

    # Asks the user for the name of the instructor and passes that into the appropriate field
    # Does not return anything
    def department(driver)

    end

    # Asks the user for the number of the course and passes that into the appropriate field
    # Does not return anything
    def course(driver)

    end

    # Retrieves all necessary info from the SEI table once its generated
    # then creates an array which holds different "Professor" objects of all the 
    # instances of that professor on the table
    def retrieveSEI(driver)
        
    end

end