require "./html.rb"
require "./scraper.rb"
require "selenium-webdriver"



# main class
class Main

    puts "Enter the output html file name:"
    file = HTML.new(gets.chomp)
    scraper = Scraper.new

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

    sleep(1)
    driver.find_element(name: '_eventId_proceed').click

    puts "waiting for duo trust to appear"
    sleep(20)

    driver.find_element(id: "trust-browser-button").click

    driver.navigate.to url

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
    
    puts "Would you like to search for another class? (1 - Yes, 2 - No): "

    professorInfo = scraper.retrieveSEI(driver)

    #Creates new HTML page object
    htmlOutput = HTML.new(file)

    #creates the string containing all HTML code
    fileContents = ""

    #Adds all the necessary HTML formatting things 
    htmlOutput.startPage(fileContents)
    htmlOutput.startHeader(fileContents)
    htmlOutput.addHeaderInfo(fileContents)
    htmlOutput.endHeader(fileContents)
    htmlOutput.startTable(fileContents)
    
    #Populates table by adding row info
    for 0...professorInfo.length()
        htmlOutput.addTableInfo(fileContents, 
            professorInfo[i].instructor, 
            professorInfo[i].course, 
            professorInfo[i].term, 
            professorInfo[i].numberOfSEIs, 
            professorInfo[i].averageRating)
    end

    
    htmlOutput.endTable(fileContents)


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

            htmlOutput.startTable(fileContents)
    
            for 0...professorInfo.length()
                htmlOutput.addTableInfo(fileContents, 
                    professorInfo[i].instructor, 
                    professorInfo[i].course, 
                    professorInfo[i].term, 
                    professorInfo[i].numberOfSEIs, 
                    professorInfo[i].averageRating)
            end

            
            htmlOutput.endTable(fileContents)

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
                    htmlOutput.endPage(fileContents)
                else
                    puts "Invalid choice, please choose a number from 1-2"
                end
            end

        elsif (repeatSearch == "2") #Does not want to do anymore searches, finishes HTML page
            
            htmlOutput.endPage(fileContents)
            loop = false
        else 
            puts "Invalid choice, please choose a number from 1-2"
        end
    end

    htmlOutput.output(fileContents)



end