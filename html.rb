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
        fileContents += "
        </body>"
        fileContents += "
        </html>"
    end

    # start header for html page
    def startHeader(fileContents)
        fileContents += "
        <header>
        <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }
    
          body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
          }
    
          h1 {
            text-align: center;
            padding: 20px;
            background-color: #c70619;
            color: white;
            font-size: 36px;
            margin-bottom: 20px;
          }
    
          h2 {
            font-size: 28px;
            font-weight: bold;
            color: #c70619;
            margin-bottom: 15px;
          }
    
          table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            background-color: white;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
          }
    
          th, td {
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #ddd;
          }
    
          th {
            background-color: #c70619;
            color: white;
            font-weight: bold;
            text-transform: uppercase;
          }
    
          tr:nth-child(even) {
            background-color: #dbdbdb;
          }
    
          tr:hover {
            background-color: #c70619;
            color: white;
          }
        </style>"
    end

    # end header for html page
    def endHeader(fileContents)
        fileContents += "
        </header>"
    end

    # add info to header, add parameters for: date, prof name, class name, course number, department, campus
    def addHeaderInfo(fileContents, date)
        fileContents += "<h1>SEI's Generated on #{date}</h1>"
    end

    # add a row of info to table
    def addTableInfo(fileContents, instructor, course, campus, term, numberOfSEIs, averageRating)

        fileContents += "<tr>
            <td>#{instructor}</td>
            <td>#{course}</td>
            <td>#{campus}</td>
            <td>#{term}</td>
            <td>#{numberOfSEIs}</td>
            <td>#{averageRating}</td>
            </tr>"
    end

    # start a formatted table from SEI
    def startTable(fileContents, searchNumber)

        # adds how many searches the user has done to the top of the table
        fileContents += "
        <h2>
        Search: ##{searchNumber}
        </h2>"

        fileContents += "<table> 
        <thead><tr>
        <th>Instructor</th>
        <th>Course</th>
        <th>Campus</th>
        <th>Term</td>
        <th># of SEI's</th>
        <th>Average Rating</th>
        </tr></thead>
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