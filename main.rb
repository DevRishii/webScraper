require "./html.rb"
require "./scraper.rb"
require "selenium-webdriver"
require "date"

# main class
class Main

    #Creates new HTML page object
    puts "Enter the output html file name:"
    htmlOutput = HTML.new(gets.chomp)
    scraper = Scraper.new
    #creates the string containing all HTML code
    fileContents = ""
    searchNumber = 1

    url = "https://registrar.osu.edu/secure/sei_search/"

    puts "What browser do you want to use? (1 = Chrome, 2 = Edge, 3 = Firefox, or 4 = Safari): "

    loop = true
    while (loop)
        browser = gets.chomp
        
        # All browsers, besides safari, will successfully run headless (doesn't open a browser window).
        # Since I'm on linux, I didn't figure out how to make the safari browser headless.
        # - Hunter
        begin
            if (browser == "1")
                options = Selenium::WebDriver::Chrome::Options.new(args: ['-headless'])
                driver = Selenium::WebDriver.for(:chrome, options: options)
                loop = false
            elsif (browser == "2") 
                options = Selenium::WebDriver::Edge::Options.new(args: ['-headless'])
                driver = Selenium::WebDriver.for(:edge, options: options)
                loop = false
            elsif (browser == "3") 
                options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
                driver = Selenium::WebDriver.for(:firefox, options: options)
                loop = false
            elsif (browser == "4") 
                driver = Selenium::WebDriver.for :safari
                loop = false
            else 
                puts "Wrong input please chose a number from 1-4: "
            end
        rescue
            puts "You do not have this browser installed. Please choose another browser."
        end
    end

    #ask user what browser to use and switch the driver based on that
    puts "System is loading..."
    driver.navigate.to url

    validLogin = false
    while validLogin == false

        validLogin = true

        puts "Enter your OSU username (name.#): "
        username = gets.chomp

        puts "Enter your OSU password: "
        password = gets.chomp

        usernameField = driver.find_element(name: 'j_username')
        usernameField.clear
        usernameField.send_keys username

        passwordField = driver.find_element(name: 'j_password')
        passwordField.clear
        passwordField.send_keys password

        driver.find_element(name: '_eventId_proceed').click

        findDuo = false
        while findDuo == false
            begin
                driver.find_element(id: 'header-text')
                findDuo = true
            rescue
                begin
                    driver.find_element(xpath: "//div[@class='error notification']")
                    puts "Your OSU username or password was not valid."
                    validLogin = false
                    findDuo = true
                rescue
                    sleep(1)
                end
            end
        end
    end

    puts "Please approve duo trust to continue."
    
    continue = false
    while continue == false
        begin
            driver.find_element(id: 'trust-this-browser-label')
            continue = true
        rescue
            begin
                driver.find_element(xpath: "//button[@class='button--primary button--xlarge try-again-button']")
                puts "Duo trust timed out. Trying again."
                driver.find_element(xpath: "//button[@class='button--primary button--xlarge try-again-button']").click
            rescue
                begin
                    driver.find_element(id: 'error-view-header-text')
                    puts "Duo trust was denied. Trying again."
                    driver.find_element(xpath: "//a[@class='action-link']").click
                rescue
                    sleep(1)
                end
            end
        end
    end

    trust = false
    while trust == false
        begin
            driver.find_element(id: "trust-browser-button").click
            trust = true
        rescue
            sleep(1)
        end
    end

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

    puts "Would you like to narrow your search by selecting a department? (1 - Yes, 2 - No): "
    loop = true
    while loop == true
        choice = gets.chomp
        if choice == "1"
            scraper.department(driver)
            loop = false
        elsif choice == "2"
            loop = false
        else
            puts "Invalid choice, please choose a number from 1-2"
        end
    end

    driver.find_element(name: "btnSearch").click

    professorInfo = scraper.retrieveSEI(driver)
    
    puts "Would you like to search for another class? (1 - Yes, 2 - No): "

    #Adds all the necessary HTML formatting things 
    fileContents = htmlOutput.startPage(fileContents)
    fileContents = htmlOutput.startHeader(fileContents)
    fileContents = htmlOutput.addHeaderInfo(fileContents, DateTime.now.strftime("%m/%d/%Y %H:%M"))
    fileContents = htmlOutput.endHeader(fileContents)

    foundSEIs = false
    # Only adds a table if at least one SEI was found
    if professorInfo.length != 0
        fileContents = htmlOutput.startTable(fileContents, searchNumber)
    
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
            searchNumber += 1
            
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
            
            puts "Would you like to narrow your search by selecting a department? (1 - Yes, 2 - No): "
            loop = true
            while loop == true
                choice = gets.chomp
                if choice == "1"
                    scraper.department(driver)
                    loop = false
                elsif choice == "2"
                    loop = false
                else
                    puts "Invalid choice, please choose a number from 1-2"
                end
            end

            driver.find_element(name: "btnSearch").click

            professorInfo = scraper.retrieveSEI(driver)

            # Only adds a table if at least one SEI was found
            if professorInfo.length != 0
                fileContents = htmlOutput.startTable(fileContents, searchNumber)
    
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
            loop = true

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

    driver.quit
    htmlOutput.output(fileContents)
    puts "Exiting program...."


end