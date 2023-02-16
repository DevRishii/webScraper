require "./html.rb"
require "./scraper.rb"
require "selenium-webdriver"



# main class
class Main

    puts "Enter the output html file name:"
    file = HTML.new(gets.chomp)
    scraper = Scraper.new

    url = "https://registrar.osu.edu/secure/sei_search/"

    #ask user what browser to use and switch the driver based on that
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to "https://registrar.osu.edu/secure/sei_search/"

    

    sleep(5)
    username = driver.find_element(name: 'j_username')
    username.send_keys "ENTER_USERNAME"
    sleep(1)
    password = driver.find_element(name: 'j_password')
    password.send_keys "ENTER_PASSWORD"
    sleep(1)
    driver.find_element(name: '_eventId_proceed').click

    sleep(10)

    driver.find_element(id: "trust-browser-button").click
    sleep(20)
    #instructorName = driver.find_element(name: "txtInstructor")
    #instructorName.send_keys "OGLE"

    #driver.find_element()



    # window_after = driver.window_handles[1]
    # driver.switch_to.window(window_after)

end