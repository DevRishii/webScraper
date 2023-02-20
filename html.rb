# output stuff and processing SEI into HTML format
class HTML

    def initialize(fileName)
    
        # This will add .html extension to the end of the file name
        # if the user did not add it or made a typo.
        if fileName.end_with?(".html")
            @fileName = fileName
        else
            @fileName = "#{fileName}.html"
        end
    end

    # start html page
    def startPage(fileContents)
        fileContents += "<!DOCTYPE html>"
        fileContents += "<html lang=\"en\">"
        
    end

    # end html page
    def endPage(fileContents)
        fileContents += "</body>"
        fileContents += "</html>"
    end

    # start header for html page
    def startHeader(fileContents)
        fileContents += "<header>"
    end

    # end header for html page
    def endHeader(fileContents)
        fileContents += "</header>"
    end

    # add info to header, add parameters for: date, prof name, class name, course number, department, campus
    def addHeaderInfo(fileContents, date)
        fileContents += "<h1>SEI's Generated on #{date}</h1>"
    end

    # add a row of info to table
    def addTableInfo(fileContents, instructor, course, campus, term, numberOfSEIs, averageRating)
        fileContents += "<tr><td>#{instructor}</td><td>#{course}</td><td>#{campus}</td><td>#{term}</td><td>#{numberOfSEIs}</td><td>#{averageRating}</td></tr>"
    end

    # start a formatted table from SEI
    def startTable(fileContents, searchNumber)

        # adds how many searches the user has done to the top of the table
        fileContents += "Search: ##{searchNumber}"

        fileContents += "<table> <style>
        table {
          border-collapse: collapse;
          width: 100%;
          margin-bottom: 30px;
        }
        
        th, td {
          padding: 8px;
          text-align: left;
          border-bottom: 1px solid #ddd;
        }
        
        tr:hover {background-color: #D6EEEE;}
        </style>
        
        <tr><td>Instructor</td><td>Course</td><td>Campus</td><td>Term</td><td># of SEI's</td><td>Average Rating</td></tr>
        "


    end

    # end a formatted table from SEI
    def endTable(fileContents)
        fileContents += "</table>"
    end

    # output html file (creates html file)
    def output(fileContents)
        puts "Saving your SEI results to #{@fileName}"
        File.open(@fileName, "w") {|f| f.write(fileContents)}     
    end

end