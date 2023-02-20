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
        puts "Please enter the name of the instructor in the following format(i.e. LastName, FirstName):"
        name = gets.chomp # gets instructor name from user 
        driver.find_element(:id, "txtInstructor").send_keys(name)
    end

    # Asks the user for the name of the campus and passes that into the appropriate field
    # Does not return anything
    def campus(driver)
        
        selectedList = driver.find_element(:xpath, "//select[@id = 'ddCampus']")
        dropdowns = selectedList.find_elements(:tag_name, "option")
        match = false
        puts "Campus abbreviations - COL, MNS, NWK, MRN, LMA, WST."
        puts "Please enter your campus abbreviation: "
        campus = gets.chomp #gets the campus from the user
        
        while match == false
            dropdowns.each do |option|
                if campus == option.text
                    option.click
                    match = true
                    break
                end
            end
            if match == false
                puts "Wrong input. Please enter your campus abbreviation again (i.e. COL for Columbus): "
                campus = gets.chomp #gets the campus from the user
            end
        end
    end

    # Asks the user for the name of the instructor and passes that into the appropriate field
    # Does not return anything
    def department(driver)

        selectedList = driver.find_element(:xpath, "//select[@id = 'ddDept']")
        dropdowns = selectedList.find_elements(:tag_name, "option")
        match = false
        puts "Please enter your department abbreviation: "
        campus = gets.chomp #gets the campus from the user
        
        while match == false
            dropdowns.each do |option|
                if campus == option.text
                    option.click
                    match = true
                    break
                end
            end
            if match == false
                puts "Wrong input. Please enter your department abbreviation again (i.e. CSE for Computer Science): "
                campus = gets.chomp #gets the campus from the user
            end
        end
    end

    # Asks the user for the number of the course and passes that into the appropriate field
    # Does not return anything
    def course(driver)
        puts "Enter the 4 digit course number."
        courseNum = gets.chomp
        courseNum = courseNum.to_i
        
        while !(courseNum > 0) || !(courseNum < 6000)
            puts "Entered wrong Number! please enter 4 digit course number."
            courseNum = gets.chomp
            courseNum = courseNum.to_i

        end
        courseNumberBox = driver.find_element(:id, "txtCourse")

        # the text box needed to be cleared before adding the course number
        courseNumberBox.clear
        courseNumberBox.send_keys(courseNum)
    end

    # Retrieves all necessary info from the SEI table once its generated
    # then creates an array which holds different "Professor" objects of all the 
    # instances of that professor on the table
    def retrieveSEI(driver)

        professors = Array.new

        begin
            table = driver.find_element(id: 'dgSEI')
            tableRows = table.find_elements(xpath: '//tr')

            for i in 1..tableRows.length - 1 do
                professors.push(Professor.new(tableRows[i].find_element(xpath: './td[last()-9]').text, 
                tableRows[i].find_element(xpath: './td[last()-8]').text, 
                tableRows[i].find_element(xpath: './td[last()-7]').text, 
                tableRows[i].find_element(xpath: './td[last()-6]').text,
                tableRows[i].find_element(xpath: './td[last()-4]').text,
                tableRows[i].find_element(xpath: './td[last()]').text))
            end
        rescue
            puts "No SEI results were found with your search criteria."
        end

        return professors
    end

end