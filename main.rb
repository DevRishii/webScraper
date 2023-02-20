require "./html.rb"
require "./scraper.rb"
require "selenium-webdriver"
require "date"



# main class
class Main

    # testP = Professor.new("testName", "testCourse", "testCampus", "testTerm", "testSEI#", "testAVGRating")
    # puts testP.instructor
    
    #Creates new HTML page object
    puts "Enter the output html file name:"
    htmlOutput = HTML.new(gets.chomp)
    scraper = Scraper.new
    #creates the string containing all HTML code
    fileContents = ""

    url = "https://registrar.osu.edu/secure/sei_search/"

    puts "What browser do you want to use? (1 = Chrome, 2 = Edge, 3 = Firefox, or 4 = Safari): "

    loop = true
    while (loop)
        browser = gets.chomp
        
        if (browser == "1")
            driver = Selenium::WebDriver.for :chrome
            loop = false
        elsif (browser == "2") 
            driver = Selenium::WebDriver.for :edge
            loop = false
        elsif (browser == "3") 
            driver = Selenium::WebDriver.for :firefox
            loop = false
        elsif (browser == "4") 
            driver = Selenium::WebDriver.for :safari
            loop = false
        else 
            puts "Wrong input please chose a number from 1-4: "
        end
    end

    #ask user what browser to use and switch the driver based on that
    puts "System is loading..."
    driver.navigate.to url

    puts "Enter your OSU username (name.#): "
    username = gets.chomp

    puts "Enter your OSU password: "
    password = gets.chomp

    usernameField = driver.find_element(name: 'j_username')
    usernameField.send_keys username

    passwordField = driver.find_element(name: 'j_password')
    passwordField.send_keys password

    driver.find_element(name: '_eventId_proceed').click

    puts "waiting for duo trust to appear"
    sleep(10)

    driver.find_element(id: "trust-browser-button").click

    puts "Would you like to search with the instructor name, by course #, or both? (1 - Instructor name, 2 - Course #, 3 - Both): "

    loop = true
    while (loop)
        searchChoice = gets.chomp
        if (searchChoice == "1")
            scraper.instructor(driver)
            loop = false
        elsif (searchChoice == "2")
            scraper.course(driver)
            loop = false
        elsif (searchChoice == "3")
            scraper.instructor(driver)
            scraper.course(driver)
            loop = false
        else 
            puts "Invalid choice, please choose a number from 1-3"
        end
    end
    
    scraper.campus(driver)
    scraper.department(driver)

    driver.find_element(name: "btnSearch").click

    professorInfo = scraper.retrieveSEI(driver)
    
    puts "Would you like to search for another class? (1 - Yes, 2 - No): "

    #Adds all the necessary HTML formatting things 
    fileContents = htmlOutput.startPage(fileContents)
    fileContents = htmlOutput.startHeader(fileContents)
    fileContents = htmlOutput.addHeaderInfo(fileContents, DateTime.now.strftime("%d/%m/%Y %H:%M"))
    fileContents = htmlOutput.endHeader(fileContents)

    foundSEIs = false
    # Only adds a table if at least one SEI was found
    if professorInfo.length != 0
        fileContents = htmlOutput.startTable(fileContents)
    
        #Populates table by adding row info
        for i in 0..professorInfo.length-1 do
            fileContents = htmlOutput.addTableInfo(fileContents, 
                professorInfo[i].instructor, 
                professorInfo[i].course,
                professorInfo[i].campus,  
                professorInfo[i].term, 
                professorInfo[i].numberOfSEIs, 
                professorInfo[i].averageRating)
        end

    
        fileContents = htmlOutput.endTable(fileContents)
        foundSEIs = true
    end

    #Start of loop to decide if user wants to generate more SEI's
    loop = true
    while (loop)
        repeatSearch = gets.chomp
        if (repeatSearch == "1") #Wants to do more searches
            
            driver.find_element(name: 'btnClear').click

            puts "Would you like to search with the instructor name, by course #, or both? (1 - Instructor name, 2 - Course #, 3 - Both): "

            #logic for search choice
            innerLoop = true
            while (innerLoop)
                searchChoice = gets.chomp
                if (searchChoice == "1")
                    scraper.instructor(driver)
                    innerLoop = false
                elsif (searchChoice == "2")
                    scraper.course(driver)
                    innerLoop = false
                elsif (searchChoice == "3")
                    scraper.instructor(driver)
                    scraper.course(driver)
                    innerLoop = false
                else 
                    puts "Invalid choice, please choose a number from 1-3"
                end
            end
            
            scraper.campus(driver)
            scraper.department(driver)

            driver.find_element(name: "btnSearch").click

            professorInfo = scraper.retrieveSEI(driver)

            # Only adds a table if at least one SEI was found
            if professorInfo.length != 0
                fileContents = htmlOutput.startTable(fileContents)
    
                for i in 0..professorInfo.length-1 do
                    fileContents = htmlOutput.addTableInfo(fileContents, 
                        professorInfo[i].instructor, 
                        professorInfo[i].course,
                        professorInfo[i].campus, 
                        professorInfo[i].term, 
                        professorInfo[i].numberOfSEIs, 
                        professorInfo[i].averageRating)
                end

            
                fileContents = htmlOutput.endTable(fileContents)
                foundSEIs = true
            end

            puts "Would you like to search for another class? (1 - Yes, 2 - No): "
            repeatSearch = gets.chomp

            innerLoop = true
            while (innerLoop)
                if (repeatSearch == "1")
                    loop = true
                    innerLoop = false
                elsif (repeatSearch == "2")
                    loop = false
                    innerLoop = false
                    # if no SEI results were found before the user is done, display that in the HTML page
                    if foundSEIs == false
                        fileContents += "<p>No SEI results were found</p>"
                    end
                    fileContents = htmlOutput.endPage(fileContents)
                else
                    puts "Invalid choice, please choose a number from 1-2"
                end
            end

        elsif (repeatSearch == "2") #Does not want to do anymore searches, finishes HTML page
            
            # if no SEI results were found before the user is done, display that in the HTML page
            if foundSEIs == false
                fileContents += "<p>No SEI results were found</p>"
            end
            fileContents = htmlOutput.endPage(fileContents)
            loop = false
        else 
            puts "Invalid choice, please choose a number from 1-2"
        end
    end

    htmlOutput.output(fileContents)



end