require "./professor.rb"
require "selenium-webdriver"

# logic for getting SEI
class Scraper #inherits Selenium::WebDriver


    def initialize(name = "", campus = "COL", dpt = "cse", course = "")
    
        @name = name
        @campus = campus
        @dpt = dpt
        @course = course
    end

    # Asks the user for the name of the instructor and passes that into the appropriate field
    # Does not return anything
    def instructor(driver)

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

        table = driver.find_element(id: 'dgSEI')
        tableRows = table.find_elements(xpath: '//tr')
        professors = Array.new

        for i in 1..tableRows.length - 1 do
            professors.push(Professor.new(tableRows[i].find_element(xpath: './td[last()-9]').text, 
            tableRows[i].find_element(xpath: './td[last()-8]').text, 
            tableRows[i].find_element(xpath: './td[last()-7]').text, 
            tableRows[i].find_element(xpath: './td[last()-6]').text,
            tableRows[i].find_element(xpath: './td[last()-4]').text,
            tableRows[i].find_element(xpath: './td[last()]').text))
        end

        return professors
    end

end